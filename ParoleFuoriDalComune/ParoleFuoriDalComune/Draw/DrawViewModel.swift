//
//  DrawViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by softwave on 03/09/22.
//

import UIKit

protocol DrawViewModel {
    
    associatedtype Model
    
    var model: Model { get }
    
    var creditsViewModel: CreditsViewModel? { get }
    
    func didLoad(view: UIView)
}

// MARK: - Abstract base class
private class _AnyDrawViewModelBase<Model>: DrawViewModel {
    
    init() {
        guard type(of: self) != _AnyDrawViewModelBase.self else {
            fatalError("_AnyDrawViewModelBase<Model> instances can not be created; create a subclass instance.")
        }
    }
    
    var model: Model {
        fatalError("Must override")
    }
    
    var creditsViewModel: CreditsViewModel? {
        fatalError("Must override")
    }
    
    func didLoad(view: UIView) {
        fatalError("Must override")
    }
}
// MARK: - Box container class
private final class _AnyDrawViewModelBox<Base: DrawViewModel>: _AnyDrawViewModelBase<Base.Model> {
    let base: Base
    init(_ base: Base) { self.base = base }

    fileprivate override var model: Model {
        base.model
    }
    
    fileprivate override var creditsViewModel: CreditsViewModel? {
        base.creditsViewModel
    }
    
    fileprivate override func didLoad(view: UIView) {
        base.didLoad(view: view)
    }
}
// MARK: - AnyDrawViewModel Wrapper
final class AnyDrawViewModel<Model>: DrawViewModel {
    private let box: _AnyDrawViewModelBase<Model>
    init<Base: DrawViewModel>(_ base: Base) where Base.Model == Model {
        box = _AnyDrawViewModelBox(base)
    }
    
    var model: Model {
        box.model
    }
    
    var creditsViewModel: CreditsViewModel? {
        box.creditsViewModel
    }
    
    func didLoad(view: UIView) {
        box.didLoad(view: view)
    }
}
