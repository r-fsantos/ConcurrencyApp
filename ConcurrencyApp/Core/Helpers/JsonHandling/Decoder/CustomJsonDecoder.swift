//
//  CustomJsonDecoder.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 04/07/25.
//

import Foundation

final class CustomJsonDecoder: JsonDecodable {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        try jsonDecoder.decode(type, from: data)
    }
}
