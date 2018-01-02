//
//  MainViewController.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 18.07.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit

import GooglePlaces
import GoogleMaps
import CoreGraphics
import UIColor_Hex_Swift



class MainViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,writeValueBackDelegate {
    
    var passedInt :Int = Int()
    
    var indexPathOfCentralCell : IndexPath = [0]
    
    
    var stepCounts = [Steps]()
    //@IBOutlet weak var collectonView: UICollectionView! = UICollectionView()
    @IBOutlet weak var stepCountLabel: UILabel? = UILabel()
    
    //@IBOutlet var readMoreButton: UIButton? = UIButton()
    var readMoreButton: UIButton = UIButton()
    //Location
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 15.0
    
    
    let nativeHeight = UIScreen.main.nativeBounds.height
    //var stepNameTextView : UITextView!
    var colorView : UIView = UIView()
    var path :UIBezierPath = UIBezierPath()
    
    let maskLayer = CAShapeLayer()
    
    fileprivate var items = [Steps]()
    var stepImagePassed  = UIImageView()
    var steps = [Steps]()
    
    var placesClient: GMSPlacesClient!
    var mapView :GMSMapView!
    var currentPlaceLatitude = Double()
    var currentPlaceLongitude = Double()
    var stepNameLabel: UILabel = UILabel()
    var button : UIButton = UIButton ()
    
    var descriptionText :UITextView = UITextView()
    var mainDescriptionText :UILabel = UILabel()
    //var readMoreButton : UIButton!
    
    var systemLanguage : String = NSLocale.current.languageCode!
    var icons = [#imageLiteral(resourceName: "step_1"),#imageLiteral(resourceName: "step_2"),#imageLiteral(resourceName: "step_3"),#imageLiteral(resourceName: "step_4"),#imageLiteral(resourceName: "step_5"),#imageLiteral(resourceName: "step_6"),#imageLiteral(resourceName: "step_7"),#imageLiteral(resourceName: "step_8"),#imageLiteral(resourceName: "step_9")]
    var collectionView: UICollectionView!
    
    var currentPage: Int = 0{
        didSet {
            let character = self.items[self.currentPage]
            self.stepNameLabel.text = character.stepTitle.uppercased()
            self.mainDescriptionText.text = character.stepText
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
                print("HEIGHT",nativeHeight)
    
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    
        UIApplication.shared.windows.last?.addSubview(myActivityIndicator)
        let spalsh = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        spalsh.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "main_view"))
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            
            print("test")
            UIApplication.shared.windows.last?.willRemoveSubview(spalsh)
            myActivityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            
        }
        
        self.view.backgroundColor = .white
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width
        let mainViewHeight = self.view.frame.height
        
        let curvedView = CurvedView(frame: CGRect(x: 0, y:0, width: width, height: mainViewHeight/4.5))
        curvedView.backgroundColor = UIColor.clear
        
        
        
        let size = curvedView.frame.size
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0.0, y: 0.0))
        bezierPath.addCurve(to: CGPoint(x: size.width, y: 0.0), controlPoint1: CGPoint(x: size.width, y: 0.0), controlPoint2: CGPoint(x: size.width, y: 0.0))
        bezierPath.addLine(to: CGPoint(x: size.width, y: size.height/2))
        bezierPath.addQuadCurve(to: CGPoint(x: 0, y: size.height/2),
                                controlPoint: CGPoint(x: size.width / 2, y:  size.height ))
        
        
        
        
        mainDescriptionText = UILabel(frame: CGRect(x:20, y:(size.height/2)+35, width: width - 40, height: self.view.frame.height/3))
        mainDescriptionText.font = UIFont.systemFont(ofSize: 18)
        mainDescriptionText.numberOfLines = 8
        mainDescriptionText.backgroundColor = .clear
        
        
        
        stepNameLabel  = UILabel(frame: CGRect(x: 40 , y: (curvedView.frame.midY)-40, width: width - 80, height: 44))
        stepNameLabel.textColor = .white
        stepNameLabel.textAlignment = .center
        stepNameLabel.numberOfLines = 2
        stepNameLabel.font =  UIFont.boldSystemFont(ofSize: 32.0)
        stepNameLabel.adjustsFontSizeToFitWidth = true
        
        //readMoreButton = UIButton(frame: CGRect(x:descriptionText.frame.maxX-120, y: descriptionText.frame.maxY, width: 120, height: 44))
//        readMoreButton = UIButton(frame: CGRect(x:mainDescriptionText.frame.maxX - 120, y: mainDescriptionText.frame.maxY, width: 120, height: 44))
//        readMoreButton?.setTitle("ЧИТАТЬ ДАЛЕЕ", for: .normal)
//        readMoreButton?.setTitleColor(UIColor("#00508c"), for: .normal)
//        readMoreButton?.titleColor(for: .normal)
//        readMoreButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        readMoreButton?.backgroundColor = .black
//        readMoreButton?.titleLabel?.adjustsFontSizeToFitWidth = true
//        readMoreButton?.translatesAutoresizingMaskIntoConstraints = false
//        readMoreButton?.isEnabled = true
//        readMoreButton?.isUserInteractionEnabled = false
//
//        mainDescriptionText.addSubview(readMoreButton!)
        
        
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor("#00508c").cgColor
        self.view.layer.addSublayer(maskLayer)
        
        
        self.view.addSubview(stepNameLabel)
        self.view.addSubview(mainDescriptionText)
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        self.buttonToMap()
        self.moreButton()
        self.items = self.createItems()
        self.currentPage = 0
        
        let layout: LNZCarouselCollectionViewLayout = LNZCarouselCollectionViewLayout()
        layout.interitemSpacing  = -30
        let collectionFrame = CGRect(x: 0, y: self.view.layer.bounds.size.height - 270, width: self.view.frame.width, height: 200)
        collectionView = UICollectionView(frame:collectionFrame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = (collectionView.frame.height)/5
        layout.minimumScaleFactor = 0.5
        layout.itemSize = CGSize(width: 180, height: 180)
        if (nativeHeight==1136){
            layout.interitemSpacing  = -17
            layout.itemSize =  CGSize(width: 130, height: 130)
            
        }
        
        self.view.addSubview(collectionView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options:[], metrics: nil, views:["v0":collectionView] ))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-100-[readButton]-10-|", options: [], metrics: nil, views: ["readButton" : readMoreButton!]))
//         self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-200-[readButton]|", options: [], metrics: nil, views: ["readButton" : readMoreButton!]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[mainDescriptionText]-[v0]-10-[buttonToMap]|", options:[], metrics: nil, views:["v0":collectionView,"buttonToMap": button ,"readMoreButton": readMoreButton,"mainDescriptionText":mainDescriptionText]))
        
    }
    
    
    func currentPlace(){
        
        
        placesClient = GMSPlacesClient.shared()
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.currentPlaceLatitude = place.coordinate.latitude
                    self.currentPlaceLongitude = place.coordinate.longitude
                    print("This is CURRENT PLACE",place.name)
                    
                    
                }
            }
        })
        
    }
    
    
    func moreButton(){
        readMoreButton = UIButton(frame: CGRect(x:mainDescriptionText.frame.maxX - 120, y: mainDescriptionText.frame.maxY-10, width: 120, height: 20))
        readMoreButton.setTitle("ЧИТАТЬ ДАЛЕЕ", for: .normal)
        readMoreButton.setTitleColor(UIColor("#00508c"), for: .normal)
        readMoreButton.titleColor(for: .normal)
        readMoreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        readMoreButton.backgroundColor = .clear
        readMoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        readMoreButton.addTarget(self, action:#selector(buttonAction) , for: .touchUpInside)
        self.view.addSubview(readMoreButton)
        
        
    }
    @objc func buttonAction(){
        performSegue(withIdentifier: "detailController", sender: UIButton!.self)
    }
    

    func buttonToMap(){
        button = UIButton (frame: CGRect(x: 10, y:self.view.layer.bounds.size.height - 70, width: self.view.layer.bounds.size.width - 20, height: 44))
        button.backgroundColor = UIColor("#00508c")
        button.layer.cornerRadius = 22
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ПОКАЗАТЬ НА КАРТЕ".uppercased(), for: .normal)
        button.addTarget(self, action:#selector(mapButton), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func mapButton(){
        performSegue(withIdentifier: "mapViewController", sender: UIButton!.self)
        //print("current page is: \(self.currentPage)")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    fileprivate func createItems() -> [Steps] {
        return stepCounts
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let displayImage = icons[indexPath.item]
        customCell.iconImage.image = displayImage
        
        return customCell
        }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        if (nativeHeight==1920){
            
            return CGSize(width: 180, height: 180)

        }
        if (nativeHeight==1334){
           return CGSize(width: 150, height: 150)
        }

        if (nativeHeight==1136){
            return CGSize(width: 120, height: 120)
        }

        return CGSize(width: 130, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapViewController", sender: UIButton!.self)
    }
   
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailController"{
            let detailViewController = segue.destination as! DetaiViewController
           
            let char = self.items[currentPage]
            detailViewController.recieveString = char.stepTitle
            detailViewController.stringImageName = icons[currentPage]
            detailViewController.stepTextPassed = char.stepText
            detailViewController.currentPlaceLongitude = self.currentPlaceLongitude
            detailViewController.currentPlaceLatitude = self.currentPlaceLatitude
        }
        if segue.identifier == "mapViewController"{
            let mapViewController = segue.destination as! MapViewController
            mapViewController.weakDelegate = self
            mapViewController.mapIndexPath = self.currentPage
            mapViewController.currentPlaceLatitude = self.currentPlaceLatitude
            mapViewController.currentPlaceLongitude = self.currentPlaceLongitude
            mapViewController.stepCurrentImage = icons[self.currentPage]
            
        }
    }
    
    func writeValueBack(value: Int) {
        self.passedInt = value
        print(value,"this is value")
    }
    
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: (collectionView?.frame.size.width)! / 2 + scrollView.contentOffset.x, y: (collectionView?.frame.size.height)! / 2 + scrollView.contentOffset.y)
        self.indexPathOfCentralCell = (collectionView?.indexPathForItem(at: centerPoint))!
        self.currentPage = indexPathOfCentralCell[1]
    
    
    
    
        DispatchQueue.main.async {
            
            
            switch self.indexPathOfCentralCell[1] {
            case 0 :
                self.maskLayer.fillColor = UIColor("#00508c").cgColor
                self.button.backgroundColor = UIColor("#00508c")
                self.readMoreButton.setTitleColor(UIColor("#00508c"), for: .normal)
            case 1 :
                self.maskLayer.fillColor = UIColor("#35a000").cgColor
                self.button.backgroundColor = UIColor("#35a000")
                self.readMoreButton.setTitleColor(UIColor("#35a000"), for: .normal)
            case 2 :
                self.maskLayer.fillColor = UIColor("#c67a00").cgColor
                self.button.backgroundColor = UIColor("#c67a00")
                self.readMoreButton.setTitleColor(UIColor("#c67a00"), for: .normal)
            case 3 :
                self.maskLayer.fillColor = UIColor("#a00092").cgColor
                self.button.backgroundColor = UIColor("#a00092")
                self.readMoreButton.setTitleColor(UIColor("#a00092"), for: .normal)
            case 4 :
                self.maskLayer.fillColor = UIColor("#ba1a00").cgColor
                self.button.backgroundColor = UIColor("#ba1a00")
                self.readMoreButton.setTitleColor(UIColor("#ba1a00"), for: .normal)
            case 5 :
                self.maskLayer.fillColor = UIColor("#3a008c").cgColor
                self.button.backgroundColor = UIColor("#3a008c")
                self.readMoreButton.setTitleColor(UIColor("#3a008c"), for: .normal)
            case 6 :
                self.maskLayer.fillColor = UIColor("#ba002b").cgColor
                self.button.backgroundColor = UIColor("#ba002b")
                self.readMoreButton.setTitleColor(UIColor("#ba002b"), for: .normal)
            case 7 :
                self.maskLayer.fillColor = UIColor("#d29600").cgColor
                self.button.backgroundColor = UIColor("#d29600")
                self.readMoreButton.setTitleColor(UIColor("#d29600"), for: .normal)
            case 8 :
                self.maskLayer.fillColor = UIColor("#50008c").cgColor
                self.button.backgroundColor = UIColor("#50008c")
                self.readMoreButton.setTitleColor(UIColor("#50008c"), for: .normal)
            default:
                self.currentPage = 0
                
            }
        }
    
    }
    
    
    
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        
        self.currentPlaceLongitude = location.coordinate.longitude
        self.currentPlaceLatitude = location.coordinate.latitude
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
    
    
}


