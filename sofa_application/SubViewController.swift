//
//  SubViewController.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 31.08.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit
import SafariServices

class SubViewController: UIViewController {
    
    var information : Modal!
    
    
    let screenSize = UIScreen.main.bounds
    let modalView : UIView = UIView()
    var dismissButton :UIButton!
    var callButton :UIButton!
    var linkButton :UIButton!
    var naviButton :UIButton!
    
    
    
    var nameLabel :String!
    var subLabel :String!
    var stepImage :UIImage!
    var URLString :String!
    var phoneNumbers :[String]!
    var schedule :[String]!
    var scheduleView : UIView!
    var scheduleLabels  = [UILabel?](repeating:nil, count: 7)
    var systemLanguage : String = NSLocale.current.languageCode!
    
    var navigationLat = Double()
    var navigationLng = Double()
    let nativeHeight = UIScreen.main.nativeBounds.height
    
    let buttonWidth = (UIScreen.main.bounds.width)/3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        information = Modal(frame: CGRect(x: 0, y: self.view.frame.maxY, width: screenSize.width, height: screenSize.height / 2.5))
        self.view.addSubview(information)
        information.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: (self.view.frame.height) - information.frame.height, left: 0, bottom: 0, right: 0))
        
        dismissFunctionButton()
        callFunctionButton()
        linkFunctionButton()
        naviFunctionButton()
        textViewDays()
        textView()
        iconview()
        passedName()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func iconview(){
        let iconView = UIImageView(frame: CGRect(x: 20, y: 15, width: 45 , height: 45))
        iconView.image = self.stepImage
        self.information.addSubview(iconView)
        
    }
    func passedName(){
        //let nameLabel = UILabel(frame: CGRect(x: 80, y: 5, width: self.view.frame.width - 80 , height: 20))
        let subLabel = UILabel(frame: CGRect(x: 80, y: 45, width: self.view.frame.width, height: 14))
        let nameLabelText: UILabel = UILabel()
        
        nameLabelText.frame = CGRect(x: 80, y: 0, width: self.view.frame.width - 170, height: 50)
        nameLabelText.numberOfLines = 0
        nameLabelText.lineBreakMode = .byWordWrapping
        nameLabelText.text = nameLabel
        nameLabelText.adjustsFontSizeToFitWidth = true
       //nameLabel.numberOfLines = 0
        //nameLabel.lineBreakMode = .byWordWrapping
       // nameLabel.text = self.nameLabel
        //nameLabel.textAlignment = .natural
        //nameLabel.font = UIFont.systemFont(ofSize: 17)
        subLabel.text = self.subLabel
        subLabel.textAlignment = .natural
        subLabel.font = UIFont.systemFont(ofSize: 12)
        self.information.addSubview(nameLabelText)
        self.information.addSubview(subLabel)
        
    }
    
    func textView() {
        let textView = UITextView(frame: CGRect(x: 110, y: 60, width: information.frame.width - 150, height: information.frame.height - 110))
        textView.textAlignment = NSTextAlignment.right
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "Helvetica", size: 12.5)
        
        
        
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = false

        if (nativeHeight==1136){
            textView.font = UIFont(name: "Helvetica", size: 13)
        }
        if (nativeHeight==1920){
            textView.font = UIFont(name: "Helvetica", size: 18.5)
        }
        if (nativeHeight==1334){
            textView.font = UIFont(name: "Helvetica", size: 16.5)
        }
        
        
        
        for  i in 0..<schedule.count{
            textView.text = (textView.text ?? "")+("\(schedule[i])\n")
            
            
        }
        
        
        self.information.addSubview(textView)
    }
    func textViewDays() {
        let textView = UITextView(frame: CGRect(x: 44, y: 60, width: 50, height: information.frame.height - 100))
        textView.textAlignment = .left
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.font = UIFont.boldSystemFont(ofSize: 13)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
        
       
        
        
        let locLang = NSLocale.current.calendar.shortWeekdaySymbols
       
//        if (nativeHeight==1136){
//            textView.font = UIFont.boldSystemFont(ofSize: 13)
//        }
        
        for  i in 0..<schedule.count {
                    if (nativeHeight==1920){
                        textView.font = UIFont.boldSystemFont(ofSize: 18.5)
                        
                        
                    }
                    if (nativeHeight==1334){
                        textView.font = UIFont.boldSystemFont(ofSize: 16.5)
                        
                    }
                    if (nativeHeight==1136){
                        textView.font = UIFont(name: "Helvetica", size: 13)
                    }
            textView.text = (textView.text ?? "")+("\(locLang[i])\n")
            
            
        }
        
        self.information.addSubview(textView)
        
        
    }
    
    func dismissFunctionButton(){
        dismissButton = UIButton (frame: CGRect(x: self.view.bounds.size.width - 44, y:20, width: 28, height: 28))
        dismissButton.backgroundColor = UIColor.clear
        dismissButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        dismissButton.addTarget(self, action:#selector(dismissSelector), for: .touchUpInside)
        information.addSubview(dismissButton)
        
    }
    
    @objc func dismissSelector(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func callFunctionButton(){
        
        callButton = UIButton (frame: CGRect(x: 0, y:information.frame.height - 44, width: buttonWidth, height: 44))
        callButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        callButton.setImage(#imageLiteral(resourceName: "call"), for: .normal)
        callButton.imageView?.contentMode = .scaleAspectFit
        callButton.layer.borderWidth = 0.2
        callButton.addTarget(self, action:#selector(callSelector), for: .touchUpInside)
        information.addSubview(callButton)
    }
    
    @objc func callSelector(){
        let alert = UIAlertController(title: "Choose a number to call", message: "Please choose which number you want to call", preferredStyle: .actionSheet)
        
        let phone = "telprompt://";
        var secondNumberAction = UIAlertAction()
        
        
        if(phoneNumbers.indices.contains(1)){
           let phone = "telprompt://";
            let number = "%20*5540"
            let dialstring = phone + number
            //print("THIS IS DIALSTRING",dialstring)
            
            secondNumberAction = UIAlertAction(title:phoneNumbers[1], style: .default) { (action) in
                if let escapedDialstirng = dialstring.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                    if let dialURL = NSURL(string: escapedDialstirng){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(dialURL as URL)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                
                
            }
            
        }
        
        let url:NSURL = NSURL(string:phone+phoneNumbers[0])!
        
        let firstNumberAction = UIAlertAction(title:phoneNumbers[0], style: .default) { (action) in
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL)
            } else {
                // Fallback on earlier versions
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        alert.addAction(firstNumberAction)
        
        if(phoneNumbers.indices.contains(1)){
            
            alert.addAction(secondNumberAction)
        }
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func linkFunctionButton(){
        
        linkButton = UIButton (frame: CGRect(x:buttonWidth, y:information.frame.height - 44, width: buttonWidth, height: 44))
        linkButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        linkButton.setImage(#imageLiteral(resourceName: "link"), for: .normal)
        linkButton.imageView?.contentMode = .scaleAspectFit
        linkButton.layer.borderWidth = 0.2
        linkButton.addTarget(self, action:#selector(linkSelector), for: .touchUpInside)
        information.addSubview(linkButton)
    }
    
    @objc func linkSelector(){
        if let url = NSURL(string:"http://\(URLString!)")  {
            //print("THIS IS NEW URLS",url)
            if #available(iOS 9.0, *) {
                let vc = SFSafariViewController(url: url as URL, entersReaderIfAvailable: true)
                present(vc, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    func naviFunctionButton(){
        
        naviButton = UIButton (frame: CGRect(x:buttonWidth*2, y:information.frame.height - 44, width: buttonWidth, height: 44))
        naviButton.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        naviButton.setImage(#imageLiteral(resourceName: "navi"), for: .normal)
        naviButton.imageView?.contentMode = .scaleAspectFit
        naviButton.layer.borderWidth = 0.2
        naviButton.addTarget(self, action:#selector(naviSelector), for: .touchUpInside)
        information.addSubview(naviButton)
    }
    
    
    
    @objc func naviSelector(){
//        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
//            UIApplication.shared.openURL(URL(string:
//                "comgooglemaps://?saddr=&daddr=\(navigationLat),\(navigationLng)&directionsmode=driving")!)
//        } else {
//            print("Can't use comgooglemaps://");
//        }
        
        let navigationSelection = UIAlertController(title: "Open in:", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            
            let wazeSelection = UIAlertAction(title: "Waze",
                                              style: .default,
                                              handler: {(action) in
                let wazeURL = "https://waze.com/ul?ll=\(self.navigationLat),\(self.navigationLng)&navigate=yes"
                UIApplication.shared.openURL(URL(string: wazeURL)!)
                                                
            })
            let image  = UIImage(named:"waze_icon")
            
            wazeSelection.setValue(image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            navigationSelection.addAction(wazeSelection)
            
//            let urlStr = "https://waze.com/ul?ll=\(navigationLat),\(navigationLng)&navigate=yes"
//            UIApplication.shared.openURL(URL(string: urlStr)!)
            
        }else {// Waze is not installed. Launch AppStore to install Waze app
            let wazeAppStore = UIAlertAction(title: "Waze in App Store",
                                          style: .default,
                                          handler: {(action)  in
                UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
            })
            let google_image = UIImage(named:"waze_icon")
            wazeAppStore.setValue(google_image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            navigationSelection.addAction(wazeAppStore)
            
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let googleNav = UIAlertAction(title: "Google Maps",
                                          style: .default,
                                          handler: {(action)  in
                let googleURL = "comgooglemaps://?saddr=&daddr=\(self.navigationLat),\(self.navigationLng)&directionsmode=driving"
                UIApplication.shared.openURL(URL(string:googleURL)!)
            })
            let google_image = UIImage(named:"google_maps_icon")
            googleNav.setValue(google_image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            navigationSelection.addAction(googleNav)
            
        }
        else {// Waze is not installed. Launch AppStore to install Waze app
            let googleNav = UIAlertAction(title: "Google Maps in App Store",
                                          style: .default,
                                          handler: {(action)  in
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/google-maps-gps-navigation/id585027354?mt=8")!)
            })
            let google_image = UIImage(named:"google_maps_icon")
            googleNav.setValue(google_image?.withRenderingMode(.alwaysOriginal), forKey: "image")
            navigationSelection.addAction(googleNav)

        }

        navigationSelection.addAction(cancelAction)
       self.present(navigationSelection, animated: true, completion: nil)
//        else {
//            // Waze is not installed. Launch AppStore to install Waze app
//            UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
//        }
        
    }
    
    
    
    
}
