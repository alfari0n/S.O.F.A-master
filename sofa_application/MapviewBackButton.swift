//
//  MapviewBackButton.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 30.12.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation
import UIKit

let buttonBack: UIButton = {
    let backButton = UIButton(type: .custom)
    backButton.frame = CGRect(x: 0, y:1, width: 38, height:38)
    backButton.backgroundColor = .clear
    backButton.setImage(UIImage(named: "back_button.png"), for: .normal)
    //backButton.setTitle("Back", for: .normal)
    backButton.setTitleColor(backButton.tintColor, for: .normal)
    backButton.addTarget(UIViewController, action: #selector(self.backAction(_:)), for: .touchUpInside)
    return backButton
}()
