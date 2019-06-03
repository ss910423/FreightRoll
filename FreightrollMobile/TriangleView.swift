//
//  TriangleView.swift
//  FreightrollMobile
//
//  Created by Alex Cyr on 4/3/18.
//  Copyright © 2018 Freightroll. All rights reserved.
//
//  https://stackoverflow.com/questions/26578741/making-a-triangle-in-a-uiview-with-a-cgrect-frame
//

import UIKit

class TriangleView: UIView {
    
    var color: UIColor?
    
    func setColor(color: UIColor){
        self.color = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        // Get Height and Width
        let layerHeight = layer.frame.height
        let layerWidth = layer.frame.width
        
        // Create Path
        let bezierPath = UIBezierPath()
        
        // Draw Points
        bezierPath.move(to: CGPoint(x: 0, y: layerHeight / 2))
        bezierPath.addLine(to: CGPoint(x: layerWidth, y: layerHeight))
        bezierPath.addLine(to: CGPoint(x: layerWidth , y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: layerHeight / 2))
        bezierPath.close()
        
        // Apply Color
        self.color?.setFill()
        bezierPath.fill()
        UIColor.white.setStroke()
        bezierPath.stroke()
        
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}
