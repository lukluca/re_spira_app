//
//  StartViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 06/09/21.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet weak var breathButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var danteButton: UIButton!
    @IBOutlet weak var postcardButton: UIButton!
    
    private var drawViewModel: DrawViewModel?
    private var sourceType: SourceType = .postcards
    
    private var spectrogramViewController: SpectrogramViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialButtonState()
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
        spectrogramViewController?.start()
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        stopButtonState()
        spectrogramViewController?.stop()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        initialButtonState()
        spectrogramViewController?.reset()
    }
    
    @IBAction func drawButtonAction(_ sender: UIButton) {
        drawingButtonState()
        
        do {
            let frequencies = spectrogramViewController?.frequencies ?? []
            
            switch sourceType {
            case .dante:
                drawViewModel = try DanteViewModelFactory().make(frequencies: frequencies)
            case .postcards: ()
            }

            performSegue(withIdentifier: SegueAction.cantica.rawValue, sender: nil)
        } catch {
            let alert = UIAlertController(title: "Errore", message: "C'è stato un errore. \(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueAction.spectrogram.rawValue:
            spectrogramViewController = segue.destination as? SpectrogramViewController
        case SegueAction.cantica.rawValue:
            let controller = segue.destination as? DrawViewController
            controller?.viewModel = drawViewModel
            controller?.rawAudioData = spectrogramViewController?.rawAudioData ?? []
        default: ()
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
}

private extension StartViewController {
    enum SegueAction: String {
        case spectrogram = "SpectrogramSegue"
        case cantica = "DrawSegue"
    }
}
