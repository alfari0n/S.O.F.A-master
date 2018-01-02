//
//  HelperViewController.swift
//  sofa_application
//
//  Created by Kirill Milititskiy on 04.09.17.
//  Copyright © 2017 Kirill Milititskiy. All rights reserved.
//

import UIKit

class HelperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createQuestions { () -> () in
            newQuestion()
        }

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createQuestions(handleComplete:(()->())){
        print("completion")
       
        handleComplete() // call it when finished s.t what you want
    }
    
    func newQuestion(){
         let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("no compeltion")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
