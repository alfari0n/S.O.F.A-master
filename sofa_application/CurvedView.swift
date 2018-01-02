//
//  CurvedView.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 17.08.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation
import UIKit
class CurvedView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addCurve(to: CGPoint(x: size.width, y: 0.0), controlPoint1: CGPoint(x: size.width, y: 0.0), controlPoint2: CGPoint(x: size.width, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: size.width, y: size.height))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: size.height ),
                                controlPoint: CGPoint(x: size.width / 2, y: size.height ))
        bezierPath.addLine(to: CGPoint(x: 0.0, y: 0.0))
        
                
        
        
    }
    
}
