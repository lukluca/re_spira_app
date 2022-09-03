//
//  Draw.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import Foundation

struct DrawPreparation {
    
    enum DrawPreparationError: Error {
        case failure
    }
    
    func execute(using values: [Float]) throws -> CommediaDrawModel {
        
        let links = try HTMLParser().extractDistributionsLinks()
        
        let cal = Calculator(data: values)
        let mode = cal.mode()
        
        let minMode = mode?.mostFrequent.min() ?? 0
        let intMin = abs(Int(minMode))
    
        let found = links.first { link in
            
            let range = link.range
            switch range.count {
            case 1:
                return intMin == range.first
            case 2:
                let startNumber = range[0]
                let endNumber = range[1]
                let numberRange = startNumber...endNumber
                return numberRange.contains(intMin)
            default:
                return false
            }
        }
        
        guard let link = found else {
            throw DrawPreparationError.failure
        }
        
        let wordLinks = try HTMLParser().extractWordLinks(from: link.href)
        
        guard !wordLinks.isEmpty else {
            throw DrawPreparationError.failure
        }
        
        let maxMode = mode?.mostFrequent.max() ?? 0
        let intMax = abs(Int(maxMode))
        
        let filtered = recursiveFilter(wordLinks: wordLinks, intMin: intMin)
        
        guard !filtered.isEmpty else {
            throw DrawPreparationError.failure
        }
    
        let value = intMax % filtered.count
        
        let wordLink = filtered[value]
        
        let models = try HTMLParser().extractDrawModels(from: wordLink.href,
                                                        using: wordLink.word)
        
        guard !models.isEmpty else {
            throw DrawPreparationError.failure
        }
        
        let diff = intMax - intMin
        
        if diff == 0, let model = models.first {
            return model
        }
        
        let division = abs((diff)/2)
        
        let index = division % models.count
        
        return models[index]
    }
    
    private func recursiveFilter(wordLinks: [HTMLParser.WordLink], intMin: Int) -> [HTMLParser.WordLink] {
        guard intMin > -1 else {
            return []
        }
        
        let filtered = wordLinks.filter {
            $0.frequency == intMin
        }
        
        if !filtered.isEmpty {
            return filtered
        }
       
        return recursiveFilter(wordLinks: wordLinks, intMin: intMin - 1)
    }
}
