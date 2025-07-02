//
//  ViewController.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import UIKit
import SwiftUI

final class FetchPostsViewController: UIViewController {
    private let contentView: FetchPostsView
    private let service: FetchPostsService

    init(contentView: FetchPostsView = FetchPostsView(),
        service: FetchPostsService = FetchPostsService()) {
        self.contentView = contentView
        self.service = service

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ConcurrencyApp"
        contentView.delegate = self
    }
}

extension FetchPostsViewController: FetchPostsViewButtonDelegate {
    func didTapButton(_ contentView: FetchPostsView) {
        print("didTapButton on contentView: \(contentView)")
        contentView.update(with: .loading("Fetching data..."))

        let queue = DispatchQueue(label: "com.renato.example.fetchQueue")

        queue.async { [self] in
            executeServiceAndUpdateUI()
        }
    }
}

extension FetchPostsViewController {
    private func executeServiceAndUpdateUI() {
        service.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let posts):
                    self.contentView.update(with: .success("Success! Fetched \(posts.count) posts."))
                    print("Fetched \(posts.count) posts successfully.")
                case .failure(let error):
                    self.contentView.update(with: .error("Failed: \(error.description)"))
                    print("Error: \(error.description)")
                }
            }
        }
    }
}
