//
//  SMNavigationController.swift
//  Silly Monks
//
//  Created by Sarath on 21/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

class SMNavigationController: ENSideMenuNavigationController,ENSideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 230.0 // optional, default is 160 ---// 230
        sideMenu?.bouncingEnabled = false
        self.sideMenuAnimationType = ENSideMenuAnimation.None
        sideMenu?.bouncingEnabled = false
        // make navigation bar showing over side menu
        view.bringSubviewToFront(navigationBar)

        // Do any additional setup after loading the view.
    }
    
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
