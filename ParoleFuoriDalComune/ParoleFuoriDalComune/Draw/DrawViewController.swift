//
//  DrawViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import UIKit

final class DrawViewController: UIViewController {
    
    var viewModel: DrawViewModel?
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
        switch segue.identifier {
        case SegueAction.spectrogram.rawValue:
            spectrogramViewController = segue.destination as? SpectrogramViewController
        case SegueAction.credits.rawValue:
            let controller = segue.destination as? CreditsTableViewController
            let poemCellViewModel = viewModel?.poemCellViewModel
            controller?.viewModel.poem = poemCellViewModel
        default: ()
        }
    }
    
    private func addTap(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        performSegue(to: .credits, sender: sender)
    }
    
    @objc private func didPressLeft(sender: UIScreenEdgePanGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
        performSegue(to: .start, sender: sender)
    }
    
    private func performSegue(to action: SegueAction, sender: Any?) {
        performSegue(withIdentifier: action.rawValue, sender: sender)
    }
}

private extension DrawViewController {
    enum SegueAction: String {
        case spectrogram = "SpectrogramSegue"
        case credits = "CreditsSegue"
        case start = "StartSegue"
    }
}
