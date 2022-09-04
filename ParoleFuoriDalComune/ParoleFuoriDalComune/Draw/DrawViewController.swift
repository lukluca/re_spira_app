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
        performSegue(withIdentifier: SegueAction.credits.rawValue, sender: sender)
    }
}

private extension DrawViewController {
    enum SegueAction: String {
        case spectrogram = "SpectrogramSegue"
        case credits = "CreditsSegue"
    }
}
