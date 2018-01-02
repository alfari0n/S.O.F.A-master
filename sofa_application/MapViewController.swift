import UIKit
import GoogleMaps
import GooglePlaces
import YNDropDownMenu
import UIColor_Hex_Swift
import AnimatedDropdownMenu



class MapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    weak var myActivityIndicator : UIActivityIndicatorView!
    let markerIcons = ["marker_1","marker_2","marker_3","marker_4","marker_5","marker_6","marker_7","marker_8","marker_9","marker_10,"]
    
    
    var markerArray  = [GMSMarker]()
    let segueIdentifier :String = "SubViewController"
    var mostInternal :String = String()
    
    
    
    var fetchedCityPlaces = [CityPlace]()
    var fetchedCoordinates = [Coordinates]()
    var feetchedCityCoordinates = [Coordinates]()
    
    var fetchedLatitude = [Any]()
    var fetchedLongitude = [Any]()
    var fetchedURL = [String]()
    
    var currentPlaceLatitude = Double()
    var currentPlaceLongitude = Double()
    
    var stepCurrentImage : UIImage!
    
    
    
    var weakDelegate :writeValueBackDelegate?
    
    @IBOutlet var newView: UIView!
    var currentLocation: CLLocation?
    
    var placesClient: GMSPlacesClient!
    
    var passedCity = String()
    
    var passed = [String]()
    var name = String()
    
    var cityLabel : UILabel = UILabel()
    
    var mapIndexPath = Int()
    var cityList :[AnyObject] = []
    var city  = [String]()
    
    var rangeview: UIView = UIView()
    var dropView :YNDropDownMenu!
    var systemLanguage : String = NSLocale.current.languageCode!
    
    var subTitleCell = UITableViewCell(style: .subtitle, reuseIdentifier: "InfoCell")
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var resultView: UITextView?
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    var locationManager = CLLocationManager()
    
    // Update the map once the user has made their selection.
    
    var zoomLevel: Float = 15.0
    var listTable: UITableView = UITableView()
    var infoTable: UITableView = UITableView()
    
    var mapView :GMSMapView = {
//        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
//        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
//                                              longitude: defaultLocation.coordinate.longitude,
//                                              zoom: 15)
        var mapView = GMSMapView()
//        let screenHeight = UIScreen.main.bounds.height
//        mapView = GMSMapView.map(withFrame: UIScreen.main.bounds, camera: camera)
//        mapView.padding = UIEdgeInsets(top: 102, left: 0, bottom: (screenHeight) / 2.5, right: 0)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        mapView.isHidden = true
//        let marker = GMSMarker()
//        marker.map = mapView
        
        return mapView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        if(didTapMyLocationButton(for:mapView)){
            print("the button is tapped")
        }
        
        
        
        super.viewDidLoad()
        //self.view.addSubview(self.mapView)
        //Indicator in tableview
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        infoTable.backgroundView = myActivityIndicator
        infoTable.separatorStyle = .none
        self.myActivityIndicator = myActivityIndicator
        
        
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        weakDelegate?.writeValueBack(value: mapIndexPath)
        
        
        
        DispatchQueue.main.async{
            
            //self.getListOfCitiesJSON()
            //self.currentPlace()
            
        }
        DispatchQueue.main.async {


//            self.view.addSubview(self.mapView)
            self.addListTable()
            self.addInfoTable()
            let frameY = CGRect(x: 5, y:20, width: UIScreen.main.bounds.width - 10, height: 44)
            self.dropView = YNDropDownMenu(frame: frameY, dropDownViews: [self.listTable], dropDownViewTitles: [""])
            self.dropView.layer.cornerRadius = 22
            self.dropView.layer.borderWidth = 0.1

            let buttonBack: UIButton = {
                let backButton = UIButton(type: .custom)
                backButton.frame = CGRect(x: 0, y:1, width: 38, height:38)
                backButton.backgroundColor = .clear
                backButton.setImage(UIImage(named: "back_button.png"), for: .normal)
                //backButton.setTitle("Back", for: .normal)
                backButton.setTitleColor(backButton.tintColor, for: .normal)
                backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
                return backButton
            }()

            let dropDownView = YNDropDownView(frame: CGRect(x: 30, y: 22, width: 40 , height: 40))
            dropDownView.backgroundColor = .clear
            self.view.insertSubview(dropDownView, aboveSubview: self.mapView)
            dropDownView.addSubview(buttonBack)
            self.mapView.addSubview(self.dropView)
            
        }
        createMap()
    }
    
    func addListTable(){
        self.listTable.frame = CGRect(x: 0, y:0, width: self.screenWidth, height: self.screenHeight - 64)
        self.listTable.backgroundColor = UIColor.clear
        self.listTable.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
        self.listTable.dataSource = self
        self.listTable.delegate = self
        
    }
    
    func addInfoTable(){
        self.infoTable.frame = CGRect(x:0, y: ((self.mapView.frame.maxY) - (self.screenHeight)/2.5), width: self.screenWidth, height: self.screenHeight / 2.5)
        self.infoTable.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
        self.infoTable.rowHeight = UITableViewAutomaticDimension
        self.infoTable.dataSource = self
        self.infoTable.delegate = self
        self.mapView.addSubview(self.infoTable)
        
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 30, y: 27, width: 30, height: 30)
        backButton.setImage(UIImage(named: "back_button.png"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.view.insertSubview(backButton, aboveSubview: self.mapView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        // Set Center
        var center = self.view.center
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
        }
        activityIndicatorView.center = center
        
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.view.addSubview(mapView)
        myActivityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
        if (fetchedCityPlaces.first == nil){
            print("fetched cities are nil")
            
            infoTable.separatorStyle = .singleLine
            self.myActivityIndicator.stopAnimating()
            //createMap()
            categoryArrays()
            self.infoTable.reloadData()
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        //self.navigationController?.view.isUserInteractionEnabled = false
    }
    
    
    func getListOfCitiesJSON(){
        fetchedCoordinates = []
        city = []
        
        let jsonUrlSrting = "https://olimshelper.herokuapp.com/\(systemLanguage)/city"
        guard let url = URL(string: jsonUrlSrting) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err)in
            guard let data = data else {
                return
            }
            _ = String(data:data,encoding:.utf8)
            
            do{
                guard let json  =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:AnyObject]] else {return}
                
                
                for info in json {
                    let name = info["name"] as! String
                    let latitude = info["latitude"] as! Double
                    let longitude = info["longitude"] as! Double
                    
                    self.city.append(name)
                    self.feetchedCityCoordinates.append(Coordinates(lat: latitude, long: longitude))
                    
                }
                
                self.passedCity = self.city.first!
                
                
                
            }catch let jsonErr
            {
                print("Json serializing",jsonErr)
            }
            
            }.resume()
        
        
    }
    
    func createMap(){
        
        placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let currentPlace : Array = [place.formattedAddress!.components(separatedBy: ",")]
                    _  = currentPlace[0][0]
                    let city = currentPlace[0][1]
                    
                    //self.passedCity = city
                    //self.dropView.changeMenu(title: city, at: 0)
                    
                    
                    
                }
            }
        })
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.padding = UIEdgeInsets(top: 102, left: 0, bottom: (screenHeight) / 2.5, right: 0)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        mapView.isHidden = true
        let marker = GMSMarker()
        marker.map = mapView

        
        
        
    }
    func currentPlace(){
        //Clear Mapview
        mapView.clear()
        
        
        //        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
        //        activityIndicator.center = self.view.center
        //        activityIndicator.hidesWhenStopped = true
        //        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //        view.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        //        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
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
                    print("CURRENT PLACE",place.name)
                    
                    
                }
            }
        })
        //        activityIndicator.stopAnimating()
        //        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    func categoryArrays(){
        
        fetchedCityPlaces = []
        fetchedCoordinates = []
        fetchedLatitude = []
        fetchedLongitude = []
        fetchedURL = []
        
        let lat = String(self.currentPlaceLatitude)
        let lng = String(self.currentPlaceLongitude)
        
        
        var radius = Int()
        
        switch mapIndexPath+1 {
        case 8:
            radius = 300
        default:
            radius = 5
        }
        
        
        
        let jsonUrlString = "https://olimshelper.herokuapp.com/step/\(systemLanguage)/\(mapIndexPath+1)/area/\(lat)/\(lng)/\(radius)"
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err)in
            
            guard let data = data else {return}
            _ = String(data:data,encoding:.utf8)
            
            
            
            do{
                guard let json  =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyObject] else {return}
                
                
                for places in json  {
                    
                    let category = places["category"] as! String
                    let lat = places["latitude"] as! Double
                    let long = places["longitude"] as! Double
                    let name = places["name"] as! String
                    let phones = places["phones"] as! [String]
                    let placeId = places["placeId"] as! String
                    let stringURL = places["url"] as! String!
                    let schedule = places["schedule"] as! [String]
                    
                    
                    
                    self.placesClient.lookUpPlaceID(placeId, callback:
                        {
                            
                            (place, error) -> Void in
                            if let error = error {
                                print("lookup place id query error: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let place = place else {
                                print("No place details for \(placeId)")
                                return
                            }
                            self.mostInternal = place.name
                            
                            
                            
                            
                            
                            self.activityIndicatorView.startAnimating()
                            self.fetchedCityPlaces.append(CityPlace(name: name, category: category,latitude:lat,longitude: long, placeId: place.name,urlString:stringURL!,phoneNumber:phones,schedule:schedule))
                            self.fetchedLatitude.append(lat)
                            self.fetchedLongitude.append(long)
                            self.fetchedURL.append(stringURL!)
                            self.createMarkers()
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.infoTable.reloadData()
                                
                                
                                
                                
                            })
                            //activityIndicator.stopAnimating()
                            
                            //                    self.fetchedCityPlaces.append(CityPlace(name: name, category: category,latitude:lat,longitude: long, placeId: placeId))
                            //self.fetchedCoordinates.append(Coordinates(lat: lat, long: long))
                            //self.fetchedLatitude.append(lat)
                            //self.fetchedLongitude.append(long)
                            //                    DispatchQueue.main.async(execute: { () -> Void in
                            //                        self.infoTable.reloadData()
                            self.activityIndicatorView.stopAnimating()
                    })
                    
                    
                    
                }
                
                
            }catch let jsonErr{
                print("Json serializing",jsonErr)
            }
            
            }.resume()
        
        
    }
    
    let backButton = {
        let backButton = UIButton(frame: CGRect(x: 5, y: 25, width: 25, height: 20))
        
        
    }
    
    func createMarkers(){
        
        
        DispatchQueue.main.async {
            
            
            
            var custLat = self.fetchedLatitude
            var custLng = self.fetchedLongitude
            var bounds = GMSCoordinateBounds()
            var arr = [GMSMarker?](repeatElement(nil, count: custLat.count))
            
            
            for i in 0..<custLat.count{
                arr[i] = GMSMarker()
                arr[i]?.position  = CLLocationCoordinate2D(latitude: custLat[i] as! CLLocationDegrees, longitude: custLng[i] as! CLLocationDegrees)
                arr[i]?.map = self.mapView
                arr[i]?.icon = UIImage.init(named: self.markerIcons[self.mapIndexPath])
                bounds  = bounds.includingCoordinate((arr[i]?.position)!)
                self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
                
            }
            
        }
        
    }
    
    func showModalView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subView = storyboard.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
        subView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(subView, animated: true, completion: nil)
        
    }
    
    // Populate the array with the list of likely places.
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == listTable{
            self.cityLabel.text = (self.city[indexPath.row] as String)
            self.dropView.changeMenu(title: self.cityLabel.text!, at: 0)
            
            let lat = self.feetchedCityCoordinates[indexPath.row].latitude
            let lng = self.feetchedCityCoordinates[indexPath.row].longitude
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(lat, lng)
            self.currentPlaceLatitude = self.feetchedCityCoordinates[indexPath.row].latitude
            self.currentPlaceLongitude = self.feetchedCityCoordinates[indexPath.row].longitude
            
            
            categoryArrays()
            self.mapView.clear()
            self.dropView.hideMenu()
            
            
            
            
        }
        if tableView == infoTable{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subView = storyboard.instantiateViewController(withIdentifier: "SubViewController") as! SubViewController
            subView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            subView.URLString = self.fetchedCityPlaces[indexPath.row].urlString
            subView.phoneNumbers = self.fetchedCityPlaces[indexPath.row].phoneNumber
            subView.schedule = self.fetchedCityPlaces[indexPath.row].schedule
            subView.stepImage  = self.stepCurrentImage
            subView.nameLabel = self.fetchedCityPlaces[indexPath.row].name
            subView.subLabel = self.fetchedCityPlaces[indexPath.row].placeId
            subView.navigationLat = self.fetchedLatitude[indexPath.row] as! Double
            subView.navigationLng = self.fetchedLongitude[indexPath.row] as! Double
            let selectedIndexCell = infoTable.indexPathForSelectedRow?.row
            
            self.mapView.clear()
            
            self.present(subView, animated: true, completion: nil)
            
            
            var custLat = self.fetchedLatitude
            var custLng = self.fetchedLongitude
            var arr = [GMSMarker?](repeatElement(nil, count: custLat.count))
            
            
            
            
            
            var isSelected : Bool = false
            
            for i in 0..<custLat.count{
                
                if(i == selectedIndexCell){
                    isSelected = true
                    if(isSelected == true){
                        arr[i] = GMSMarker()
                        arr[i]?.position  = CLLocationCoordinate2D(latitude: custLat[i] as! CLLocationDegrees, longitude: custLng[i] as! CLLocationDegrees)
                        arr[i]?.map = self.mapView
                        
                        
                        self.mapView.selectedMarker = arr[i]
                        self.mapView.selectedMarker?.icon = UIImage.init(named: self.markerIcons[self.mapIndexPath])
                    }
                }
                if(i < selectedIndexCell!){
                    isSelected = false
                    if(isSelected == false){
                        arr[i] = GMSMarker()
                        arr[i]?.position  = CLLocationCoordinate2D(latitude: custLat[i] as! CLLocationDegrees, longitude: custLng[i] as! CLLocationDegrees)
                        arr[i]?.map = self.mapView
                        self.mapView.selectedMarker = arr[i]
                        self.mapView.selectedMarker?.icon = GMSMarker.markerImage(with: .black)
                        self.mapView.selectedMarker?.icon = UIImage.init(named: "marker_10")
                    }
                }
                if(i > selectedIndexCell!){
                    isSelected = false
                    if(isSelected == false){
                        arr[i] = GMSMarker()
                        arr[i]?.position  = CLLocationCoordinate2D(latitude: custLat[i] as! CLLocationDegrees, longitude: custLng[i] as! CLLocationDegrees)
                        arr[i]?.map = self.mapView
                        self.mapView.selectedMarker = arr[i]
                        self.mapView.selectedMarker?.icon = UIImage.init(named: "marker_10")
                        
                    }
                }
            }
        }
    }
    
    
    
    func highlight(_ marker: GMSMarker) {
        if mapView.selectedMarker != nil {
            
        }
        do {
            marker.icon = UIImage(named:"marker_9")
        }
    }
    
    func unhighlightMarker(_ marker: GMSMarker) {
        
        
        marker.icon = UIImage(named:"marker_10")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == listTable{
            
            return self.city.count
        }
        
        if tableView == infoTable{
            
            return fetchedCityPlaces.count
        }
        
        
        return -1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView ==  infoTable{
            return 84
        }
        
        return 44
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == infoTable{
            
            return (fetchedCityPlaces.first == nil) ? 0 : 1
            
            
        }
        
        //return (fetchedCityPlaces.first == nil) ? 0 : 1
        return 1
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell()
        if tableView == listTable{
            let cell = tableView.dequeueReusableCell( withIdentifier: "listCell",for:indexPath as IndexPath)
            
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = self.city[indexPath.row] as String
            
            return cell
        }
        
        if tableView == infoTable{
            
            let cellSubTitle: UITableViewCell = UITableViewCell(style:.subtitle, reuseIdentifier: "infoCell")
            cellSubTitle.textLabel?.numberOfLines = 0
            cellSubTitle.textLabel?.lineBreakMode = .byWordWrapping
            let dispatch = DispatchQueue.global()
            dispatch.async {
                let name = self.fetchedCityPlaces[indexPath.row].name
                let adress = self.fetchedCityPlaces[indexPath.row].placeId
                
                
                DispatchQueue.main.async {
                    
                    cellSubTitle.textLabel?.text = name
                    cellSubTitle.imageView?.image = self.stepCurrentImage
                    cellSubTitle.detailTextLabel?.text = adress
                    
                    
                }
            }
            
            return cellSubTitle
            
        }
        
        return cell
    }
}


class CityPlace{
    var name : String
    var category : String
    var latitude : CLLocationDegrees
    var longitude: CLLocationDegrees
    var placeId  : String
    var urlString: String
    var phoneNumber :[String]
    var schedule :[String]
    
    init(name : String , category : String,latitude :CLLocationDegrees,longitude : CLLocationDegrees,placeId:String,urlString:String,phoneNumber:[String],schedule:[String]) {
        self.name = name
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
        self.placeId = placeId
        self.urlString = urlString
        self.phoneNumber = phoneNumber
        self.schedule = schedule
    }
}

struct Coordinates {
    var latitude : Double
    var longitude : Double
    init(lat:Double,long:Double) {
        self.latitude = lat
        self.longitude = long
    }
}


// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            infoTable.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        
        self.currentPlaceLatitude = location.coordinate.latitude
        self.currentPlaceLongitude = location.coordinate.latitude
        
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        locationManager.stopUpdatingLocation()
        
    }
    
    func startRecievingSignificantLocationChanges(){
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways{
            return
        }
        if !CLLocationManager.significantLocationChangeMonitoringAvailable(){
            return
        }
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
    }
}

extension MapViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    }
}

