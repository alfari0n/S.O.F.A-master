//
//  DetailViewController.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 19.07.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit
import GooglePlaces
import UIColor_Hex_Swift

class DetaiViewController: UIViewController  {
    
    
    
    
    @IBOutlet var stepName: UILabel!
    @IBOutlet var stepTextView: UITextView!
    //to map button
    var buttonToMap :UIButton = UIButton()
    // currnet step number
    var currentPage :Int = Int()
    
    var stringImageName : UIImage!
    var recieveString :String!
    var stepTextPassed :String!
    var placesClient: GMSPlacesClient!
    
    var passedCity = String()
    var currentPlaceLatitude = Double()
    var currentPlaceLongitude = Double()
    
    let screenSize: CGRect = UIScreen.main.bounds
    let maskLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let mainViewheight = self.view.frame.height
        let width = screenSize.width
        let curvedView = CurvedView(frame: CGRect(x: 0, y: 0, width: width, height: mainViewheight/4.5))
        curvedView.backgroundColor = UIColor.clear
        
        
        
        let size = curvedView.frame.size
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addCurve(to: CGPoint(x: size.width, y: 0.0), controlPoint1: CGPoint(x: size.width, y: 0.0), controlPoint2: CGPoint(x: size.width, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: size.width, y: size.height/2))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: size.height/2),
                                controlPoint: CGPoint(x: size.width / 2, y:  size.height ))
        bezierPath.addClip()
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor("#00508c").cgColor
        self.view.layer.addSublayer(maskLayer)
        
        //self.view.addSubview(curvedView)
        self.view.layer.backgroundColor = UIColor.white.cgColor
        //self.stepTextView = UITextView(frame: CGRect(x:20, y:(size.height/2)+70, width: width - 40, height: self.view.frame.height/3))
        self.stepTextView.text = self.stepTextPassed
        self.stepTextView.font = UIFont.systemFont(ofSize: 18)
        self.stepTextView.showsVerticalScrollIndicator = false
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    
                    
                    print(place.name)
                    print("this is coordinates of current place\(place.coordinate)")
                    self.currentPlaceLatitude = place.coordinate.latitude
                    self.currentPlaceLongitude = place.coordinate.longitude
                    
                    let currentPlace : Array = [place.formattedAddress!.components(separatedBy: ",")]
                    
                    let city = currentPlace[0][1]
                    self.passedCity = city
                    
                    
                    
                }
            }
        })
        
        
        
        
        
        
        
         stepName  = UILabel(frame: CGRect(x: 40 , y: (curvedView.frame.midY)-40, width: width - 80, height: 44))
        
        //stepName  = UILabel(frame: CGRect(x: (self.view.frame.midX) - 60 , y: (curvedView.frame.midY)-40, width: 120, height: 44))
        self.stepName.text = recieveString.uppercased()
        self.stepName.font = UIFont.boldSystemFont(ofSize: 32.0)
        self.stepName.textColor = .white
        self.stepName.numberOfLines = 2
        self.stepName.textAlignment = .center
        stepName.adjustsFontSizeToFitWidth = true
        self.view.addSubview(stepName)
        
        button()
        cityButton()
        changeLayerColor()
        
        
    }
    func button(){
        buttonToMap = UIButton (frame: CGRect(x: 10, y:self.view.layer.bounds.size.height - 50, width: self.view.layer.bounds.size.width - 20, height: 44))
        buttonToMap.backgroundColor = .clear
        buttonToMap.layer.cornerRadius = 22
        buttonToMap.setTitleColor(.white, for: .normal)
        buttonToMap.setTitle("ПОКАЗАТЬ В МОЕМ ГОРОДЕ", for: .normal)
        buttonToMap.addTarget(self, action:#selector(mapButton), for: .touchUpInside)
        buttonToMap.titleLabel?.adjustsFontSizeToFitWidth = true
        self.view.addSubview(buttonToMap)
    }
    
    @objc func mapButton(){
        performSegue(withIdentifier: "mapViewController_2", sender: UIButton!.self)
        
    }
    
    func backButton(){
        //let backButton = UIButton(frame: CGRect(x: 10, y: 27, width: <#T##Double#>, height: <#T##Double#>)
    }
    
    
    fileprivate func cityButton(){
        let button = UIButton (frame: CGRect(x: self.view.layer.bounds.size.width - 60 , y:self.view.layer.bounds.size.height - 50, width: 40 , height: 40))
        
        self.view.addSubview(button)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapViewController_2"{
            let dvc = segue.destination as! MapViewController
            
            
            
            dvc.mapIndexPath = self.currentPage
            dvc.currentPlaceLatitude = self.currentPlaceLatitude
            dvc.currentPlaceLongitude = self.currentPlaceLongitude
            dvc.stepCurrentImage = self.stringImageName
            
        }
    }
    
    func changeLayerColor(){
        switch currentPage {
        case 0:
            self.buttonToMap.backgroundColor = UIColor("#00508c")
        case 1 :
            self.maskLayer.fillColor = UIColor("#35a000").cgColor
            self.buttonToMap.backgroundColor = UIColor("#35a000")
        case 2 :
            self.maskLayer.fillColor = UIColor("#c67a00").cgColor
            self.buttonToMap.backgroundColor = UIColor("#c67a00")
        case 3 :
            self.maskLayer.fillColor = UIColor("#a00092").cgColor
            self.buttonToMap.backgroundColor = UIColor("#a00092")
        case 4 :
            self.maskLayer.fillColor = UIColor("#ba1a00").cgColor
            self.buttonToMap.backgroundColor = UIColor("#ba1a00")
        case 5 :
            self.maskLayer.fillColor = UIColor("#3a008c").cgColor
            self.buttonToMap.backgroundColor = UIColor("#3a008c")
        case 6 :
            self.maskLayer.fillColor = UIColor("#ba002b").cgColor
            self.buttonToMap.backgroundColor = UIColor("#ba002b")
        case 7 :
            self.maskLayer.fillColor = UIColor("#d29600").cgColor
            self.buttonToMap.backgroundColor = UIColor("#d29600")
        case 8 :
            self.maskLayer.fillColor = UIColor("#50008c").cgColor
            self.buttonToMap.backgroundColor = UIColor("#50008c")
        default:
            currentPage = 0
        }
    }
    
}


