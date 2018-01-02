//
//  Modal.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 31.08.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation
import UIKit
import  PureLayout


class Modal: UIView {
    
    var shouldSetupConstraints = true
    var detailView : UIImageView!
    
    
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height / 2.5))
        detailView.backgroundColor = UIColor.white
        
        detailView.autoSetDimension(.height, toSize: screenSize.height / 2.5)
        self.addSubview(detailView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            detailView.autoPinEdgesToSuperviewEdges(with:UIEdgeInsets.zero,excludingEdge:.bottom)
            
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
}
