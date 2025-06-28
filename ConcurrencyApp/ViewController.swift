//
//  ViewController.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import UIKit
import SwiftUI

final class ViewController: UIViewController {
    // UI Elements
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0 // Allow multiple lines for error messages
        return label
    }()

    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch Posts", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private let service: FetchPostsService

    init(service: FetchPostsService = FetchPostsService()) {
        self.service = service

        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("\(self) deinitialized")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Default background color
        title = "ConcurrencyApp"

        setupUI()
        setupConstraints()

        // Add action for the button
        fetchButton.addTarget(self, action: #selector(fetchButtonTapped), for: .touchUpInside)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(statusLabel)
        view.addSubview(fetchButton)

        // Initially hide the status label
        statusLabel.text = ""
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            fetchButton.heightAnchor.constraint(equalToConstant: 50),
            fetchButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    // MARK: - Actions
    @objc private func fetchButtonTapped() {
        // 1. Show loading indicator and clear previous status
        activityIndicator.startAnimating()
        statusLabel.text = "Fetching data..."
        statusLabel.textColor = .systemGray
        fetchButton.isEnabled = false // Disable button during fetch

        executeServiceAndUpdateUI()
    }

    private func executeServiceAndUpdateUI() {
        // 2. Call the API client
        service.fetchPosts { [weak self] result in
            // Ensure UI updates are on the main thread (already handled by APIClient, but good to be explicit here)
            DispatchQueue.main.async {
                guard let self = self else { return }

                // 3. Hide loading indicator and enable button
                self.activityIndicator.stopAnimating()
                self.fetchButton.isEnabled = true

                // 4. Update UI based on result
                switch result {
                case .success(let posts):
                    self.statusLabel.text = "Success! Fetched \(posts.count) posts."
                    self.statusLabel.textColor = .systemGreen
                    print("Fetched \(posts.count) posts successfully.")
                    // You can now use the 'posts' array, e.g., display in a table view
                case .failure(let error):
                    self.statusLabel.text = "Failed: \(error.description)"
                    self.statusLabel.textColor = .systemRed
                    print("Error: \(error.description)")
                }
            }
        }
    }
}
