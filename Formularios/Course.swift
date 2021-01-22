//
//  Course.swift
//  Formularios
//
//  Created by Jacob Aguilar on 12-01-21.
//

import Foundation

struct Course: Identifiable {
    var id = UUID()
    var name: String
    var image: String
    var type: String
    var priceLevel: Int
    var featured: Bool = false
    var purchased: Bool = false
}
