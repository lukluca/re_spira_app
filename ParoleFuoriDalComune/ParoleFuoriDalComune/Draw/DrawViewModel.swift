//
//  DrawViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit

protocol DrawViewModel {
    
    var poemCellViewModel: PoemCellViewModel { get }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void)
}

extension DrawViewModel {
    
    func setContraints(to view: UIView, subview: UIView, length: CGFloat, and addTap: (UIView) -> Void) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(subview)

        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subview.heightAnchor.constraint(equalToConstant: length),
            subview.widthAnchor.constraint(equalToConstant: length)
        ])
        
        addTap(subview)
    }
}
