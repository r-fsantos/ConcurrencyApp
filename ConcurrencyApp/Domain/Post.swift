//
//  Post.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 27/06/25.
//

import Foundation

// MARK: - Data Model

// Define a simple struct to decode the JSON response for a Post.
// The Decodable protocol allows us to easily parse JSON into this struct.
struct Post: Decodable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
