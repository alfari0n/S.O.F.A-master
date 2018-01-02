//
//  Buttons.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 02.09.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit

func buttonToMap(){
    let button :UIButton = UIButton (frame: CGRect(x: 10, y:view.layer.bounds.size.height - 70, width: view.layer.bounds.size.width - 20, height: 44))
    button.backgroundColor = UIColor("#00508c")
    button.layer.cornerRadius = 22
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Show on Map".uppercased(), for: .normal)
    button.addTarget(self, action:#selector(mapButton), for: .touchUpInside)
    self.view.addSubview(button)
}

