//
//  CarouselCollectionViewCell.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 18.07.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    var iconImage : UIImageView!
    //text in cell
    var textView : UITextView!
    static let identifier = "CarouselCollectionViewCell"
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImage = UIImageView(frame: CGRect(x:0 , y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.white.cgColor
        self.addSubview(iconImage)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
        self.layer.borderWidth = 3.0
        
        self.layer.borderColor = UIColor.darkGray.cgColor
        //UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
    }
}
