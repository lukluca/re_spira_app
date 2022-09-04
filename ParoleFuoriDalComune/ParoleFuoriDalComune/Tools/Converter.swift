//
//  Converter.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 04/09/22.
//

import Foundation

enum ConverterError: Error {
    case isNotFinite
    case isNan
}

extension Float {
    
    func toAbsInt() throws -> Int {
        guard !isInfinite else {
            throw ConverterError.isNotFinite
        }
        guard !isNaN else {
            throw ConverterError.isNan
        }
        
        return abs(Int(self))
    }
}
