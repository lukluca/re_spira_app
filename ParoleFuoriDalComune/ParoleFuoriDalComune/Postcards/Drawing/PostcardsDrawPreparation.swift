//
//  PostcardsDrawPreparation.swift
//  ParoleFuoriDalComune
//
//  Created by softwave on 04/09/22.
//

import Foundation


struct PostcardsDrawPreparation {
    
    enum DrawPreparationError: Error {
        case missingTitle
    }
    
    func execute(using values: [Float]) throws -> PostcardDisplayModel {
        let files = try Files().getPoemAndImage(at: 1)
        
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
