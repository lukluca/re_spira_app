//
//  Cantica.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import Foundation

struct CommediaDrawModel {
    let cantica: Cantica
    let canto: Int
    let verso: Int
    let word: String
}

enum Cantica: Int {
    case inferno
    case purgatorio
    case paradiso
}

extension Cantica: CustomStringConvertible {
    var description: String {
        switch self {
        case .inferno:
            return "Inferno"
        case .purgatorio:
            return "Purgatorio"
        case .paradiso:
            return "Paradiso"
        }
    }
}
