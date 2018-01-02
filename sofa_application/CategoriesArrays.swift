//
//  CategoriesArrays.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 25.08.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation



class CategoriesArrays  {
    let  systemLanguage : String = NSLocale.current.languageCode!
    
    func categoryArraysNonVoid(lat:Double,lng:Double){
        
        //        fetchedCityPlaces = []
        //        fetchedCoordinates = []
        //        fetchedLatitude = []
        //        fetchedLongitude = []
        
        //let lat = String(self.currentPlaceLatitude)
        //let lng = String(self.currentPlaceLongitude)
        //        print("this is LNG \(self.currentPlaceLongitude)")
        //let jsonUrlString = "https://olimshelper.herokuapp.com/\(systemLanguage)/bank/area/%2032.6025718/35.2940228/1"
        let jsonUrlString = "https://olimshelper.herokuapp.com/\(systemLanguage)/bank/area/%20\(lat)/\(lng)/1"
        print(jsonUrlString)
        guard let url = URL(string: jsonUrlString) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err)in
            
            guard let data = data else {return}
            _ = String(data:data,encoding:.utf8)
            
            
            
            do{
                guard let json  =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyObject] else {return}
                //print(json)
                
                for places in json  {
                    
                    let category = places["category"] as! String
                    let lat = places["latitude"] as! Double
                    let long = places["longitude"] as! Double
                    let name = places["name"] as! String
                    //let id  = places["id"] as! Dictionary<String,AnyObject>
                    //var name  = id["name"] as! String
                    //let category   = id["category"] as! String
                    //                    let coordinate = places["coordinate"] as! Dictionary<String,AnyObject>
                    //                    let longitude = coordinate["longitude"] as! Double
                    //                    let latitude = coordinate["latitude"] as! Double
                    
                    //print(category)
                    //print(id)
                    //print(name)
                    //print(category)
                    //print(lat)
                    //print(long)
                    //self.mapViewController.fetchedCityPlaces.append(CityPlace(name: name, category: category, latitude: lat, longitude: long))
                    
                    //self.infoTable.reloadData()
                    
                    
                    
                    
                    
                }
                //print("this is fetchedLatitude: \(self.fetchedLatitude)")
                //                print(self.fetchedCityPlaces)
                //                print(self.fetchedCoordinates)
                
            }catch let jsonErr{
                print("Json serializing",jsonErr)
            }
            
            }.resume()
        
        
    }
    
    //    func createMarkersNonVoid(lat:Double,lng:Double){
    //        //print("this is in CM funtion\(self.fetchedLatitude)")
    //        var marker : [Int: GMSMarker] = [:]
    //        var custLat = self.fetchedLatitude
    //        var custLng = self.fetchedLongitude
    //
    //        for i in 0..<custLat.count{
    //            marker[i] = GMSMarker()
    //            marker[i]?.position = CLLocationCoordinate2D(latitude: lat[i] as! CLLocationDegrees, longitude: lng[i] as! CLLocationDegrees)
    //            marker[i]?.map = mapView
    //            marker[i]?.icon = GMSMarker.markerImage(with: UIColor.red)
    //        }
    //        
    //        
    //    }
    
}
