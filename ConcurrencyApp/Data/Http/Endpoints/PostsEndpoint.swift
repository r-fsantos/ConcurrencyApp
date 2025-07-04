//
//  PostsEndpoint.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 04/07/25.
//

import Foundation

enum PostsEndpoint: Endpoint {
    case fetchPosts

    var path: String {
        switch self {
        case .fetchPosts:
            return "/posts"
        }
    }

    var method: RequestMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var headers: [String : String]? {
        nil
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}
