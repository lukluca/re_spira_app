//
//  Converter.swift
//  ParoleFuoriDalComune
//
//  Created by softwave on 04/09/22.
//

import Foundation

enum ConverterError: Error {
    case isNotFinite
    case isNan
}

extension Float {
    
    func toAbsInt() throws -> Int {
        guard !self.isInfinite else {
            throw ConverterError.isNotFinite
        }
        guard !self.isNaN else {
            throw ConverterError.isNan
        }
        
        return abs(Int(self))
    }
}
