//
//  PostcardsViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit

struct PostcardsViewModelFactory {
    func make(frequencies: [Float]) throws -> PostcardsViewModel {
        return PostcardsViewModel()
    }
}

struct PostcardsViewModel: DrawViewModel {
    
    
    var creditsViewModel: CreditsViewModel {
        fatalError("Must implement!")
    }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void) {
        
    }
}
