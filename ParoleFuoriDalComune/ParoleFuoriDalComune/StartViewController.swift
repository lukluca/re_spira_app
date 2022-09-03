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
    
    #if targetEnvironment(simulator)
    private var timer: Timer?
    private var frequencies = [Float]()
    #else
    #endif
    
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
        startsSectrogram()
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        stopButtonState()
        stopSectrogram()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        initialButtonState()
        resetSectrogram()
    }
    
    @IBAction func drawButtonAction(_ sender: UIButton) {
        drawingButtonState()
        
        do {
            
            #if targetEnvironment(simulator)
            let frequencies = self.frequencies
            #else
            let frequencies = spectrogramViewController?.frequencies ?? []
            #endif
            
            switch sourceType {
            case .dante:
                drawViewModel = try DanteViewModelFactory().make(frequencies: frequencies)
            case .postcards:
                drawViewModel = try PostcardsViewModelFactory().make(frequencies: frequencies)
            }

            performSegue(withIdentifier: SegueAction.cantica.rawValue, sender: nil)
        } catch {
            let alert = UIAlertController(title: R.string.localizable.errorTitle(),
                                          message: R.string.localizable.errorMessage() + "\(error)", preferredStyle: .alert)
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

#if targetEnvironment(simulator)
private extension StartViewController {
    func startsSectrogram() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    func resetSectrogram() {
        frequencies.removeAll()
    }
    func stopSectrogram() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func fireTimer() {
        frequencies.append(Float.random(min: -10, max: 10))
    }
}
#else
private extension StartViewController {
    func startsSectrogram() {
        spectrogramViewController?.start()
    }
    func resetSectrogram() {
        spectrogramViewController?.reset()
    }
    func stopSectrogram() {
        spectrogramViewController?.stop()
    }
}
#endif

#if targetEnvironment(simulator)
private extension Float {

    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random()) / Float(0xFFFFFFFF)
    }

    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
#else
#endif
