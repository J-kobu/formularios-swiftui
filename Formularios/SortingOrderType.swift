//
//  SortingOrderType.swift
//  Formularios
//
//  Created by Jacob Aguilar on 10-02-21.
//

import Foundation

enum SortingOrderType: Int, CaseIterable { //el protocolo CaseIterable, nos permite recorrer el enum con .allCases si así lo deseamos
    case alphabetical = 0
    case featured = 1
    case purchased = 2
    
    //Constructor
    init(type: Int) {
        switch type {
        case 0:
            self = .alphabetical
        case 1:
            self = .featured
        case 2:
            self = .purchased
        default:
            self = .alphabetical
        }
    }
    
    var description: String { // variable autocomputada
        switch self {
        case .alphabetical:
            return "Alfabéticamente"
        case .featured:
            return "Los favoritos al inicio"
        case .purchased:
            return "Los comprados al inicio"
        }
        
    }
    
    func predicateSort() -> ((Course, Course) -> Bool) { //Esta función no es privada, debido a que debemos acceder a ella desde las otras pantallas 
        switch self {
        case .alphabetical:
            return {$0.name > $1.name}
        case .featured:
            return {$0.featured && !$1.featured}
        case .purchased:
            return {$0.purchased && !$1.purchased}
        }
    }
    
    
}
