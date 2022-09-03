//
//  SpectrogramViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 07/09/21.
//

import UIKit
import BBToast

final class SpectrogramViewController: UIViewController {

    /// The audio spectrogram layer.
    private var audioSpectrogram: AudioSpectrogram?
    
    private(set) var frequencies = [Float]()
    private(set) var rawAudioData = [Int16]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSpectogram()
        
        view.backgroundColor = .black
    }

    override func viewDidLayoutSubviews() {
        audioSpectrogram?.frame = view.frame
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    //MARK: Start / Stop
    
    func start() {
        setSpectogram(darkMode: false)
        
        audioSpectrogram?.didAppendFrequencies = { [weak self] values in
            self?.frequencies.append(contentsOf: values)
        }
        
        audioSpectrogram?.didAppendAudioData = { [weak self] values in
            self?.rawAudioData.append(contentsOf: values)
        }
        
        audioSpectrogram?.startRunning()
    }
    
    func start(rawAudioData: [Int16]) {
        resetSpectogram()
        
        setSpectogram(darkMode: false)
        
        audioSpectrogram?.startRunning(rawAudioData: rawAudioData)
    }
    
    func stop() {
        audioSpectrogram?.stopRunning()
    }
    
    func reset() {
        frequencies.removeAll()
        resetSpectogram()
    }
    
    private func resetSpectogram() {
        audioSpectrogram?.removeFromSuperlayer()
    }
    
    private func setSpectogram(darkMode: Bool? = nil) {
        guard audioSpectrogram?.superlayer == nil else {
            return
        }
        let spectogram: AudioSpectrogram
        if let darkMode = darkMode {
            spectogram = AudioSpectrogram(darkMode: darkMode)
        } else {
            spectogram = AudioSpectrogram()
        }
        self.audioSpectrogram = spectogram
        bindSpectogram()
        
        spectogram.configure()
        
        view.layer.addSublayer(spectogram)
    }
    
    private func bindSpectogram() {
        audioSpectrogram?.showErrorMessage = { [weak self] errorString in
            DispatchQueue.main.async {
                self?.showBBToast(errorString)
            }
        }
    }
}
