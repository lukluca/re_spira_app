//
//  Commedia.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 12/09/21.
//

import Foundation

struct Book {
    
    struct Volume {
        let type: String
        let name: String
        let children: [Canto]
    }
    
    struct Canto {
        let type: String
        let name: String
        let children: [Terzina]
    }
    
    struct Terzina {
        let type: String
        let number: Int
        let children: [Verso]
    }
    
    struct Verso {
        let text: String
        let type: String
        let number: Int
        let text_length: Int
    }
    
    let children: [Volume]
}

extension Book: Decodable { }

extension Book.Volume: Decodable { }
extension Book.Canto: Decodable { }
extension Book.Terzina: Decodable { }
extension Book.Verso: Decodable { }

struct CommediaDisplayModel {
    
    struct Detail {
        let canto: String
        let terzina: [String]
    }
    
    let model: CommediaDrawModel
    let detail: Detail
}

struct Commedia {
    
    enum CommediaError: Error {
        case noFile
        case noCanto
        case noTerzina
    }
    
    func enrich(model: CommediaDrawModel) throws -> CommediaDisplayModel {
        
        let book = try getBook()
        
        let volume = book.children.first {
            $0.type == "Volume" && $0.name == model.cantica.description
        }
        
        let canto = volume?.children.enumerated().first { (index, element) in
            index == (model.canto - 1) && element.type == "Canto"
        }?.element
        
        let terzina = canto?.children.first {
            $0.type == "Terzina" && $0.children.contains(where: { verso in
                verso.number == model.verso
            })
        }
        
        guard let cantoName = canto?.name else {
            throw CommediaError.noCanto
        }
        
        guard let versi = terzina?.children else {
            throw CommediaError.noTerzina
        }
        
        let texts = versi.map { $0.text }
        
        let detail = CommediaDisplayModel.Detail(canto: cantoName, terzina: texts)
        return CommediaDisplayModel(model: model, detail: detail)
    }
    
    private func getBook() throws -> Book {
        guard let path = Bundle.main.path(forResource: "divina_commedia", ofType: "json") else {
            throw CommediaError.noFile
        }

        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
    
        let decoder = JSONDecoder()
        return try decoder.decode(Book.self, from: data)
    }
}
