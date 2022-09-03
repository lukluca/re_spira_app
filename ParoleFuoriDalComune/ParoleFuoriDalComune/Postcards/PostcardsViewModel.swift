//
//  PostcardsViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit

struct PostcardsViewModelFactory {
    func make(frequencies: [Float]) throws -> PostcardsViewModel {
        
        let files = try Files().getPoemAndImage(at: 1)
        
        let poem = Poem(position: 1, title: "Post", text: files.poem, image: files.image)
        
        return PostcardsViewModel(poem: poem)
    }
}

struct Poem {
    let position: Int
    let title: String
    let text: String
    let image: UIImage?
}

struct PostcardsViewModel: DrawViewModel {
    
    private let poem: Poem
    
    init(poem: Poem) {
        self.poem = poem
    }
    
    var creditsViewModel: CreditsViewModel {
        CreditsViewModel(title: poem.title,
                         subtitle: poem.text)
    }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void) {
        
        let imageView = UIImageView(image: poem.image)
        
        view.addSubview(imageView)
    }
}

