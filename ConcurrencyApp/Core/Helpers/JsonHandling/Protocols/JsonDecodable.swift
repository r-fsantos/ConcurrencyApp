//
//  JsonDecodable.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 04/07/25.
//

import Foundation

// TODO: Abstract JsonDecodable to some Model protocol, that should be inherited for all Models
protocol JsonDecodable {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
