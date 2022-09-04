//
//  PostcardsViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit

struct PostcardsViewModelFactory {
    func make(frequencies: [Float]) throws -> PostcardsViewModel {
        let model = try PostcardsDrawPreparation().execute(using: frequencies)
        return PostcardsViewModel(model: model)
    }
}

struct Poem {
    let position: Int
    let title: String
    let text: String
}

struct PostcardsViewModel: DrawViewModel {
    
    private let model: PostcardDisplayModel
    
    init(model: PostcardDisplayModel) {
        self.model = model
    }
    
    var poemCellViewModel: PoemCellViewModel {
        PoemCellViewModel(title: model.linearPoem.title,
                          subtitle: model.linearPoem.text)
    }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void) {
        
        let imageView = UIImageView(image: model.visualPoem)
         
        imageView.contentMode = .scaleAspectFit
        
        let length = view.frame.height/3
        
        setContraints(to: view, subview: imageView, length: length, and: addTap)
    }
}

