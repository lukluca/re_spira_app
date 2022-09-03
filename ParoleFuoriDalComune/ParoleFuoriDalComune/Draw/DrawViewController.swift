//
//  DrawViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import UIKit
import KDTree

final class DrawViewController: UIViewController {
    
    var display: DrawDisplayModel?
    var rawAudioData = [Int16]()
    
    private var spectrogramViewController: SpectrogramViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let display = display else {
            return
        }
        
        let model = display.model
        
        switch model.cantica {
        case .inferno:
            drawInferno(model: model)
        case .purgatorio:
            drawPurgatorio(model: model)
        case .paradiso:
            drawParadiso(model: model)
        }
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
            
            let word = display?.model.word ?? ""
            let cantica = display?.model.cantica.description ?? ""
            let canto = display?.detail.canto ?? ""
            let terzina = display?.detail.terzina.joined(separator: "\n") ?? ""
            let creditsViewModel = CreditsViewModel(title: "\(cantica), \(canto), parola '\(word)'",
                                                    subtitle: terzina)
            controller?.viewModel = creditsViewModel
        default: ()
        }
    }
    
    private func drawInferno(model: DrawModel) {
        let ring = UIView()
        
        let ray = CGFloat(3 * model.verso)
    
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ray, height: ray)).cgPath
        
        let color = UIColor(hue: CGFloat(model.cantica.rawValue),
                            saturation: CGFloat(model.canto),
                            brightness: CGFloat(model.verso), alpha: 1)
        
        circleLayer.strokeColor = color.cgColor
        circleLayer.lineWidth = 1
        circleLayer.fillColor = UIColor.clear.cgColor
        ring.layer.addSublayer(circleLayer)
        
        ring.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ring)
        NSLayoutConstraint.activate([
            ring.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ring.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ring.heightAnchor.constraint(equalToConstant: ray),
            ring.widthAnchor.constraint(equalToConstant: ray)
        ])
        
        addTap(to: ring)
    }
    
    private func drawPurgatorio(model: DrawModel) {
        let parabola = UIView()
        
        let ray = CGFloat(3 * model.verso)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: ray))
        path.addQuadCurve(to: CGPoint(x: ray, y: ray),
                          controlPoint: CGPoint(x: ray/2, y: 0))
        
        let color = UIColor(hue: 0.7,
                            saturation: CGFloat(model.canto),
                            brightness: CGFloat(model.verso),
                            alpha: 1)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineWidth = 1
        layer.fillColor = UIColor.clear.cgColor
        parabola.layer.addSublayer(layer)
        
        parabola.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parabola)
        NSLayoutConstraint.activate([
            parabola.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parabola.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            parabola.heightAnchor.constraint(equalToConstant: ray),
            parabola.widthAnchor.constraint(equalToConstant: ray)
        ])
        
        addTap(to: parabola)
    }
    
    private func drawParadiso(model: DrawModel) {
        let constellation = UIView()
        
        let length = 200 * model.verso
        let lengthFloat = CGFloat(length)
        
        let range = 0..<(10  * model.canto)
        
        let points = range.map { _ -> CGPoint in
            let x = Int.random(in: 0..<length)
            let y = Int.random(in: 0..<length)
            return CGPoint(x: x, y: y)
        }
        
        let startIndex = Int.random(in: range)
        
        let path = UIBezierPath()
       
        addLines(startingFrom: startIndex, points: points)
    
        let color = UIColor(hue: 0.7,
                            saturation: CGFloat(model.canto),
                            brightness: CGFloat(model.verso),
                            alpha: 1)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.lineWidth = 1
        layer.fillColor = UIColor.clear.cgColor
        constellation.layer.addSublayer(layer)
        
        constellation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(constellation)
        NSLayoutConstraint.activate([
            constellation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            constellation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            constellation.heightAnchor.constraint(equalToConstant: lengthFloat),
            constellation.widthAnchor.constraint(equalToConstant: lengthFloat)
        ])
        
        addTap(to: constellation)
        
        func nearest(to point: CGPoint, inside points: [CGPoint]) -> CGPoint? {
            let tree = KDTree(values: points)
            return tree.nearest(to: point)
        }
        
        func addLines(startingFrom index: Int, points: [CGPoint]) {
            let startPoint = points[index]
            
            path.move(to: startPoint)
            
            if let next = nearest(to: startPoint, inside: points) {
                path.addLine(to: next)
            }
            
            if let next = nearest(to: startPoint, inside: points) {
                path.addLine(to: next)
                
                var variable = points
                variable.remove(at: index)
                
                recursiveAddLine(point: next, points: variable)
            }
        }
        
        func recursiveAddLine(point: CGPoint, points: [CGPoint]) {
            guard !points.isEmpty else {
                return
            }
            
            if let next = nearest(to: point, inside: points) {
                path.addLine(to: next)
                
                if let index = points.firstIndex(of: next) {
                    var variable = points
                    variable.remove(at: index)
                    recursiveAddLine(point: next, points: variable)
                }
            }
        }
    }
    
    private func addTap(to view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
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
