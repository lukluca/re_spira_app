//
//  DrawViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by softwave on 03/09/22.
//

import UIKit

protocol DrawViewModel {
    
    var creditsViewModel: CreditsViewModel { get }
    
    func didLoad(view: UIView, addTap: (UIView) -> Void)
}
