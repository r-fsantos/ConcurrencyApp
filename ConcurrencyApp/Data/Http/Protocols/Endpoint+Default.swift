//
//  Endpoint+Default.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 04/07/25.
//

import Foundation

extension Endpoint {
    var host: String {
        "jsonplaceholder.typicode.com"
    }

    var headers: [String: String]? {
        nil
    }

    var queryItems: [URLQueryItem]? {
        nil
    }

    var components: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components
    }

    var url: URL {
        guard let url = components.url else {
            fatalError("Error when creating URL")
        }
        return url
    }
}
