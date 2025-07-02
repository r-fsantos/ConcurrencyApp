//
//  FetchPostsView.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 29/06/25.
//

import UIKit

final class FetchPostsView: UIView {
    // MARK: - View state properties
    private(set) var currentState: ViewState = .idle {
        didSet {
            configure(with: currentState)
        }
    }

    enum ViewState {
        case idle
        case loading(String)
        case success(String)
        case error(String)

        var activityIndicatorAnimating: Bool {
            switch self {
            case .loading: return true
            default : return false
            }
        }

        var statusText: String {
            switch self {
            case .idle: return ""
            case .loading(let message): return message
            case .success(let message): return message
            case .error(let message): return message
            }
        }

        // TODO: This should be from a DesignSystem
        var statusTextColor: UIColor {
            switch self {
            case .idle: return .label
            case .loading: return .systemGray
            case .success: return .systemGreen
            case .error: return .systemRed
            }
        }

        var buttonEnabled: Bool {
            switch self {
            case .loading: return false
            default: return true
            }
        }
    }


    // MARK: - Private UI elements
    // TODO: Create a Design System for labels, texts, fonts and colors
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
        label.numberOfLines = 0
        return label
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Fetch Posts", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    weak var delegate: FetchPostsViewButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(self) deinit")
    }

    // MARK: - Public methods
    func update(with newState: ViewState) {
        currentState = newState
    }

    // MARK: - private logic
    private func setupUI() {
        setupViewCode()

        // TODO: Abstract that to ViewState?
        statusLabel.text = ""
        backgroundColor = .systemBackground
        button
            .addTarget(
                self,
                action: #selector(buttonTapped),
                for: .touchUpInside
            )
    }

    @objc private func buttonTapped() {
        delegate?.didTapButton(self)
    }

    private func configure(with state: ViewState) {
        state.activityIndicatorAnimating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        statusLabel.text = state.statusText
        statusLabel.textColor = state.statusTextColor
        button.isEnabled = state.buttonEnabled
    }
}


extension FetchPostsView: ViewCodable {
    func setupViewCode() {
        buildHierarchy()
        setupConstraints()
    }

    func buildHierarchy() {
        addSubview(activityIndicator)
        addSubview(statusLabel)
        addSubview(button)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),

            statusLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
