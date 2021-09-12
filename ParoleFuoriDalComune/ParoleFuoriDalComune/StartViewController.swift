//
//  StartViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 06/09/21.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var breathButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private var drawModel: DrawDisplayModel?
    
    
    private var spectrogramViewController: SpectrogramViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        initialButtonState()
    }
    
    //MARK: IBAction

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
            let model = try DrawPreparation().execute(using: spectrogramViewController?.frequencies ?? [])
            let display = try Commedia().enrich(model: model)
            
            drawModel = display
            performSegue(withIdentifier: SegueAction.cantica.rawValue, sender: nil)
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueAction.spectrogram.rawValue:
            spectrogramViewController = segue.destination as? SpectrogramViewController
        case SegueAction.cantica.rawValue:
            let controller = segue.destination as? CanticaViewController
            controller?.display = drawModel
            controller?.rawAudioData = spectrogramViewController?.rawAudioData ?? []
        default: ()
        }
    }
    
    private func initialButtonState() {
        breathButton.isEnabled = true
        stopButton.isEnabled = false
        drawButton.isEnabled = false
        resetButton.isEnabled = false
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
    }
}

private extension StartViewController {
    enum SegueAction: String {
        case spectrogram = "SpectrogramSegue"
        case cantica = "CanticaSegue"
    }
}
