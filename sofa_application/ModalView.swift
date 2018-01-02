//
//  ModalView.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 31.08.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation
import UIKit

class ModalView: UIView {
    
     let mapViewControlelr = MapViewController()
    override init(frame: CGRect) {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        super.init(frame: CGRect(x: 0, y: (mapViewControlelr.mapView.frame.maxY) - (screenHeight)/2.5, width: screenWidth, height: screenHeight / 2.5));      backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
}
