//
//  PostcardsDrawPreparation.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 04/09/22.
//

import Foundation


struct PostcardsDrawPreparation {
    
    enum DrawPreparationError: Error {
        case missingTitle
        case noMinCalculated
        case noMaxCalculated
    }
    
    func execute(using values: [Float]) throws -> PostcardDisplayModel {
        let mostFrequent = Calculator(data: values).mode()?.mostFrequent
        
        guard let min = try mostFrequent?.min()?.toAbsInt() else {
            throw DrawPreparationError.noMinCalculated
        }
        
        guard let max = try mostFrequent?.max()?.toAbsInt() else {
            throw DrawPreparationError.noMaxCalculated
        }
        
        let position = (((min + max)/2) % 15) + 1
        
        let files = try Files().getPoemAndImage(at: position)
        
        let fullText = files.poem
        
        let lines = fullText.split(separator: "\n")
        
        guard let first = lines.first else {
            throw DrawPreparationError.missingTitle
        }
        
        let dropped = lines.dropFirst()
        
        let text = dropped.joined(separator: "\n")
    
        let poem = Poem(position: 1, title: String(first), text: text)
        
        return PostcardDisplayModel(linearPoem: poem, visualPoem: files.image)
    }
}
