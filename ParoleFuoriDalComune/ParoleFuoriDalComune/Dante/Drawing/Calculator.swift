//
//  Calculator.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 08/09/21.
//

import Foundation

struct Calculator {
    
    let data: [Float]
    
    //media
    func mean() -> Double {
        data.mean
    }
    
    //mediana
    func median() -> Double {
        data.median
    }
    
    //moda
    func mode() -> Mode<Float>? {
        data.mostFrequent
    }
}


private extension Array where Element == Float {
    var median: Double {
        let sortedArray = sorted()
        if count % 2 != 0 {
            return Double(sortedArray[count / 2])
        } else {
            return Double(sortedArray[count / 2] + sortedArray[count / 2 - 1]) / 2.0
        }
    }
}

private extension Array where Element == Float {
    var mean: Double {
        let sum = self.reduce(0, +)
        
        let mean = Double(sum) / Double(self.count)
        return Double(mean)
    }
}

private extension Array where Element == Float {
    var mode: Double {
        let sum = self.reduce(0, +)
        
        let mean = Double(sum) / Double(self.count)
        return Double(mean)
    }
}

typealias Mode<Element> = (mostFrequent: [Element], count: Int)

extension Sequence where Element: Hashable {
    
    var frequency: [Element: Int] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
    var mostFrequent: Mode<Element>? {
        guard let maxCount = frequency.values.max() else { return nil }
        return (frequency.compactMap { $0.value == maxCount ? $0.key : nil }, maxCount)
    }
}
