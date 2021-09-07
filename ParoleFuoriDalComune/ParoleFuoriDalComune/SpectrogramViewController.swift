//
//  SpectrogramViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 07/09/21.
//

import UIKit

class SpectrogramViewController: UIViewController {

    /// The audio spectrogram layer.
    private var audioSpectrogram = AudioSpectrogram()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioSpectrogram.contentsGravity = .resize
        view.layer.addSublayer(audioSpectrogram)
        
        view.backgroundColor = .black
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
    
    //MARK: Start / Stop
    
    func start() {
        if audioSpectrogram.superlayer == nil {
            audioSpectrogram = AudioSpectrogram()
            view.layer.addSublayer(audioSpectrogram)
        }
        audioSpectrogram.startRunning()
    }
    
    func stop() {
        audioSpectrogram.stopRunning()
    }
    
    func reset() {
        audioSpectrogram.removeFromSuperlayer()
    }
}
