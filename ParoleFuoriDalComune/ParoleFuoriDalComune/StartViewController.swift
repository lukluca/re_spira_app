//
//  StartViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 06/09/21.
//

import UIKit
import SpectrogramView

typealias SpectrogramController = SpectrogramView.SpectrogramController
typealias SimulatorSpectrogramController = SpectrogramView.SimulatorSpectrogramController

final class StartViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var breathButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var danteButton: UIButton!
    @IBOutlet weak var postcardButton: UIButton!
    
    private var drawViewModel: (any DrawViewModel)?
    private var sourceType: SourceType = .postcards
    
    private var spectrogramController: (any SpectrogramController)?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let typedInfo = R.segue.startViewController.spectrogramSegue(segue: segue) {
            #if targetEnvironment(simulator)
            spectrogramController = SimulatorSpectrogramController()
            #else
            spectrogramController = typedInfo.destination
            #endif
            return
        }
        
        if let typedInfo = R.segue.startViewController.drawSegue(segue: segue) {
            let controller = typedInfo.destination
            controller.viewModel = drawViewModel
            controller.rawAudioData = spectrogramController?.rawAudioData ?? []
        }
    }
    
    //MARK: IBAction
    
    @IBAction func danteButtonAction(_ sender: UIButton) {
       setDanteType()
    }
    
    @IBAction func postcardButtonAction(_ sender: UIButton) {
        setPostcardsType()
    }

    @IBAction func breathButtonAction(_ sender: UIButton) {
        recordingButtonState()
        startSpectrogram()
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        stopButtonState()
        stopSpectrogram()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        reset()
    }
    
    @IBAction func drawButtonAction(_ sender: UIButton) {
        drawingButtonState()
        
        let frequencies = spectrogramController?.frequencies ?? []
        
        do {
            switch sourceType {
            case .dante:
                drawViewModel = try DanteViewModelFactory().make(frequencies: frequencies)
            case .postcards:
                drawViewModel = try PostcardsViewModelFactory().make(frequencies: frequencies)
            }

            performSegue(withIdentifier: R.segue.startViewController.drawSegue, sender: nil)
        } catch {
            presentAlert(from: error)
        }
    }
    
    private func initialButtonState() {
        breathButton.isEnabled = true
        stopButton.isEnabled = false
        drawButton.isEnabled = false
        resetButton.isEnabled = false
        setCurrentTypeButtonState()
    }
    
    private func recordingButtonState() {
        breathButton.isEnabled = false
        stopButton.isEnabled = true
        drawButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    private func stopButtonState() {
        breathButton.isEnabled = false
        stopButton.isEnabled = false
        drawButton.isEnabled = true
        resetButton.isEnabled = true
    }
    
    private func drawingButtonState() {
        breathButton.isEnabled = false
        stopButton.isEnabled = false
        drawButton.isEnabled = false
        resetButton.isEnabled = false
        disableAllTypeButtons()
    }
    
    private func reset() {
        initialButtonState()
        resetSpectrogram()
    }
    
    private func setCurrentTypeButtonState() {
        switch sourceType {
        case .dante:
            setDanteButtonState()
        case .postcards:
            setPostcardsButtonState()
        }
    }
    
    private func setDanteType() {
        sourceType = .dante
        setDanteButtonState()
    }
    
    private func setPostcardsType() {
        sourceType = .postcards
        setPostcardsButtonState()
    }
    
    private func setDanteButtonState() {
        danteButton.isEnabled = false
        postcardButton.isEnabled = true
    }
    
    private func setPostcardsButtonState() {
        danteButton.isEnabled = true
        postcardButton.isEnabled = false
    }
    
    private func disableAllTypeButtons() {
        danteButton.isEnabled = false
        postcardButton.isEnabled = false
    }
    
    private func presentAlert(from error: any Error) {
        let nsError = error as NSError
        
        let title: String
        let message: String
        
        if nsError.domain == NSCocoaErrorDomain && nsError.code == 256 {
            title = R.string.localizable.noConnectionErrorTitle()
            message = R.string.localizable.noConnectionErrorMessage()
        } else {
            title = R.string.localizable.errorTitle()
            message = R.string.localizable.errorMessage() + "\(error)"
        }
        
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        alert.addAction(UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
            self?.reset()
        })
        present(alert, animated: true)
    }
}

//MARK: - Spectrogram wrappers

private extension StartViewController {
    func startSpectrogram() {
        spectrogramController?.start()
    }
    func resetSpectrogram() {
        spectrogramController?.reset()
    }
    func stopSpectrogram() {
        spectrogramController?.stop()
    }
}


