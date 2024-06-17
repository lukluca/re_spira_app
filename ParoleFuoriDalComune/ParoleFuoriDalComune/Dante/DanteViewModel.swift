//
//  DanteViewModel.swift
//  ParoleFuoriDalComune
//
//  Created by Luca Tagliabue on 03/09/22.
//

import UIKit
import KDTree
 
struct DanteViewModelFactory {
    
    func make(frequencies: [Float]) throws -> DanteViewModel {
        let model = try CommediaDrawPreparation().execute(using: frequencies)
        let display = try Commedia().enrich(model: model)
        return DanteViewModel(display: display)
    }
}

struct DanteViewModel: DrawViewModel {
    
    private let display: CommediaDisplayModel
    
    var poemCellViewModel: PoemCellViewModel {
        let word = display.model.word
        let cantica = display.model.cantica.description
        let canto = display.detail.canto
        let terzina = display.detail.terzina.joined(separator: "\n")
        return PoemCellViewModel(title: "\(cantica), \(canto), parola '\(word)'",
                                 subtitle: terzina)
    }
    
    init(display: CommediaDisplayModel) {
        self.display = display
    }
    
    @MainActor
    func didLoad(view: UIView, addTap: (UIView) -> Void) {
        
        let model = display.model
        
        switch model.cantica {
        case .inferno:
            drawInferno(model: model, inside: view, addTap: addTap)
        case .purgatorio:
            drawPurgatorio(model: model, inside: view, addTap: addTap)
        case .paradiso:
            drawParadiso(model: model, inside: view, addTap: addTap)
        }
    }
    
    @MainActor
    private func drawInferno(model: CommediaDrawModel,
                             inside view: UIView,
                             addTap: (UIView) -> Void) {
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
        
        setConstraints(to: view, subview: ring, length: ray, and: addTap)
    }
    
    @MainActor
    private func drawPurgatorio(model: CommediaDrawModel,
                                inside view: UIView,
                                addTap: (UIView) -> Void) {
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

        setConstraints(to: view, subview: parabola, length: ray, and: addTap)
    }
    
    @MainActor
    private func drawParadiso(model: CommediaDrawModel,
                             inside view: UIView,
                             addTap: (UIView) -> Void) {
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

        setConstraints(to: view, subview: constellation, length: lengthFloat, and: addTap)
        
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
