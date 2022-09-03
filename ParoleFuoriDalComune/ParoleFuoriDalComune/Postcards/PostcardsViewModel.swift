//
//  PostcardsViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by softwave on 03/09/22.
//

import UIKit

struct PostcardsViewModel: DrawViewModel {
    
    
    var creditsViewModel: CreditsViewModel {
        fatalError("Must implement!")
    }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void) {
        
    }
}
