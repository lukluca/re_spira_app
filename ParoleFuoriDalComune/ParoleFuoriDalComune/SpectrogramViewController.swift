//
//  SpectrogramViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 07/09/21.
//

import UIKit

class SpectrogramViewController: UIViewController {

    /// The audio spectrogram layer.
    let audioSpectrogram = AudioSpectrogram()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioSpectrogram.contentsGravity = .resize
        view.layer.addSublayer(audioSpectrogram)
  
        view.backgroundColor = .black
        
        audioSpectrogram.startRunning()
    }

    override func viewDidLayoutSubviews() {
        audioSpectrogram.frame = view.frame
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }

}
