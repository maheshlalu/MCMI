//
//  SMProfileViewController.swift
//  SMSample
//
//  Created by CX_One on 7/28/16.
//  Copyright © 2016 CX_One. All rights reserved.
//

import UIKit

class SMProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func logOutBtnAction(sender: AnyObject) {
        
        
    }
    
       
//    @IBAction func favoritesBtnAction(sender: AnyObject) {
//        
//        let favoritesViewController = UserFavoritesViewController(nibName: "UserFavoritesViewController", bundle: nil)
//        self.navigationController?.pushViewController(favoritesViewController, animated: true)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true

        
        // Do any additional setup after loading the view.
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
