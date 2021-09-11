//
//  CanticaViewController.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 09/09/21.
//

import UIKit
import KDTree

class CanticaViewController: UIViewController {
    
    var model: DrawModel?
    var rawAudioData = [Int16]()
    
    private var spectrogramViewController: SpectrogramViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else {
            return
        }
        
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
        default: ()
        }
    }
    
    private func drawInferno(model: DrawModel) {
        let ring = UIView()
        
        let ray = CGFloat(3 * model.verso)
    
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ray, height: ray)).cgPath
        
        let color = UIColor(hue: CGFloat(model.cantica.rawValue), saturation: CGFloat(model.canto), brightness: CGFloat(model.verso), alpha: 1)
        
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
    }
    
    private func drawPurgatorio(model: DrawModel) {
        let parabola = UIView()
        
        let ray = CGFloat(3 * model.verso)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: ray))
        path.addQuadCurve(to: CGPoint(x: ray, y: ray),
                          controlPoint: CGPoint(x: ray/2, y: 0))
        
        let color = UIColor(hue: 0.7, saturation: CGFloat(model.canto), brightness: CGFloat(model.verso), alpha: 1)
        
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
    
        let color = UIColor(hue: 0.7, saturation: CGFloat(model.canto), brightness: CGFloat(model.verso), alpha: 1)
        
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
}

private extension CanticaViewController {
    enum SegueAction: String {
        case spectrogram = "SpectrogramSegue"
    }
}
