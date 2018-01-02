//
//  SplashViewController.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 08.09.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    var systemLanguage : String = NSLocale.current.languageCode!
    var newSteps = [Steps]()
    var icons = [String]()
    let myStoryBoard = UIStoryboard()
    
    
     override func viewDidLoad() {
        
        let splash = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        splash.image = #imageLiteral(resourceName: "main_view")
        view.addSubview(splash)
       
        runCodeAndComplete(parse: parseDescription, presentView: presentMainView)
       
    }
    
    func runCodeAndComplete (parse:() -> () ,presentView:() -> ()){
        parse()
        presentView()
    }
    
    
    func presentMainView(){
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            myActivityIndicator.stopAnimating()
            let mainViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            mainViewController.stepCounts = self.newSteps
            let navController = UINavigationController(rootViewController: mainViewController)
            self.present(navController, animated:true, completion: nil)
            
        }
        
        view.addSubview(myActivityIndicator)
    }
    
    
    func parseDescription(){
        newSteps = []
        let urlString  = "https://olimshelper.herokuapp.com/\(self.systemLanguage)"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err)in
            
            guard let data = data else {return}
            _ = String(data:data,encoding:.utf8)
            //print("this is datastring",dataString)
            do{
                guard let json  =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject> else {return}
                //print(json)
                self.icons = ["step_1","step_2","step_3","step_4","step_5","step_6","step_7","step_8","step_9"]
                
               
                let steps = json["steps"] as! [[String:Any]]
                
                for info in steps{

                    self.newSteps.append(Steps.init(stepTitle: info["title"] as! String, stepText: info["description"] as! String, stepCount: info["numberOfStep"] as! Int))
                    
                    
                    self.newSteps = self.newSteps.sorted(by: { (arg0, arg1) -> Bool in
                        return arg0.stepCount < arg1.stepCount
                    })
                    
                }
                
                
                
                
            }catch let jsonErr{
                print("Json serializing",jsonErr)
            }
            
            }.resume()
        
        
    }

}
