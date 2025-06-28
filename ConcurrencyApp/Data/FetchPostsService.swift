//
//  FetchPostsService.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import Foundation

// Important note for Xcode Playgrounds:
// If you are running this in an Xcode Playground, you might need to
// add `PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true`
// at the top to allow asynchronous operations to complete.

// ApiClient class responsible for making network requests.
final class FetchPostsService {
    // MARK: - Properties
    private let baseURL = "https://jsonplaceholder.typicode.com"

    // MARK: - Public Methods

    /// Fetches a list of posts from the JSONPlaceholder API.
    /// - Parameter completion: A closure that is called when the request completes.
    ///   It returns a Result enum, either containing an array of Posts on success
    ///   or an APIError on failure.
    func fetchPosts(completion: @escaping (Result<[Post], APIError>) -> Void) {
        // Construct the full URL for the /posts endpoint.
        guard let url = URL(string: "\(baseURL)/posts") else {
            completion(.failure(.invalidURL))
            return
        }

        // Create a URLSession data task.
        // This task will handle the network request and provide a response, data, or error.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensure the completion handler is called on the main thread,
            // especially if this data will update UI.
            //            DispatchQueue.main.async {
            // Check for network errors first.
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            // Ensure data was received.
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }

            // Attempt to decode the JSON data into an array of Post objects.
            do {
                let decoder = JSONDecoder()
                // Set the key decoding strategy if your JSON keys don't match Swift conventions
                // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let posts = try decoder.decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                // If decoding fails, return a decoding error.
                completion(.failure(.decodingError(error)))
            }
            //            }
        }
        // Start the network request.
        task.resume()
    }
}
