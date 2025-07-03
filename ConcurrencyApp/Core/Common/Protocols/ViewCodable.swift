//
//  ViewCodable.swift
//  ConcurrencyApp
//
//  Created by Renato F. dos Santos Jr on 02/07/25.
//

import Foundation

protocol ViewCodable: AnyObject {
    func setupViewCode()
    func buildHierarchy()
    func setupConstraints()
}
