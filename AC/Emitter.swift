//
//  Emitter.swift
//  AC
//
//  Created by AndreOsip on 7/13/17.
//  Copyright © 2017 AndreOsip. All rights reserved.
//

import UIKit

class Emitter {
    static func get(with image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    
    static func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        
        cell.birthRate = 1.5
        cell.lifetime = 20
        cell.velocity = CGFloat(40)
        cell.emissionLongitude = (180 * (.pi/180))
        cell.emissionRange = (45 * (.pi/180))
        
        cell.scale = 0.11
        cell.scaleRange = 0.1
        
        cells.append(cell)
        
        return cells
        
    }
    
}
