//
//  Endpoint.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 04/07/25.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var path: String { get }
    var components: URLComponents { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
}
