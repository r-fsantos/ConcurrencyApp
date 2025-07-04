//
//  FetchPostsService.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import Foundation

// TODO: Abstract protocol
final class FetchPostsService {
    // MARK: Private properties
    private let request: URLRequest
    private let jsonDecoder: JsonDecodable
    private let session: URLSession
    private var task: URLSessionDataTask?

    // MARK: - Public Methods
    init(
        request: URLRequest = PostsEndpoint.fetchPosts.request,
        jsonDecoder: JsonDecodable = CustomJsonDecoder(),
        session: URLSession = URLSession.shared
    ) {
        self.request = request
        self.jsonDecoder = jsonDecoder
        self.session = session
    }

    /// Fetches a list of posts from the JSONPlaceholder API.
    /// - Parameter completion: A closure that is called when the request completes.
    ///   It returns a Result enum, either containing an array of Posts on success
    ///   or an APIError on failure.
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        task = session.dataTask(
            with: request
        ) { data, response, error in

            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }

            do {
                let posts = try self.jsonDecoder.decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task?.resume()
    }

    func cancelFetch() {
        task?.cancel()
    }
}
