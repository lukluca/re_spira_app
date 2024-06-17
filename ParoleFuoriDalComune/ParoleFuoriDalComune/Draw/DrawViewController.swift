//
//  DrawViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import UIKit

final class DrawViewController: UIViewController {
    
    var viewModel: (any DrawViewModel)?
    var rawAudioData = [Int16]()
    
    private var spectrogramViewController: SpectrogramViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
                                                                    action: #selector(didPressLeft))
        screenEdgeRecognizer.edges = .left
        view.addGestureRecognizer(screenEdgeRecognizer)
        
        viewModel?.didLoad(view: view, addTap: addTap(to:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spectrogramViewController?.start(rawAudioData: rawAudioData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let typedInfo = R.segue.drawViewController.spectrogramSegue(segue: segue) {
            spectrogramViewController = typedInfo.destination
            return
        }
        if let typedInfo = R.segue.drawViewController.creditsSegue(segue: segue) {
            let controller = typedInfo.destination
            let poemCellViewModel = viewModel?.poemCellViewModel
            controller.viewModel.poem = poemCellViewModel
        }
    }
    
    private func addTap(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: R.segue.drawViewController.creditsSegue, sender: sender)
    }
    
    @objc private func didPressLeft(sender: UIScreenEdgePanGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
        performSegue(withIdentifier: R.segue.drawViewController.startSegue, sender: sender)
    }
}
