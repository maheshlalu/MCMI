//
//  SMProfileViewController.swift
//  SMSample
//
//  Created by CX_One on 7/28/16.
//  Copyright © 2016 CX_One. All rights reserved.
//

import UIKit

class SMProfileViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    var strProfile : String!


    
       
//    @IBAction func favoritesBtnAction(sender: AnyObject) {
//        
//        let favoritesViewController = UserFavoritesViewController(nibName: "UserFavoritesViewController", bundle: nil)
//        self.navigationController?.pushViewController(favoritesViewController, animated: true)
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDPImage()
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2
        self.imgView.clipsToBounds = true
        self.imgView.layer.borderWidth = 3.0
        self.imgView.layer.borderColor = UIColor.whiteColor().CGColor

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDPImage() {
        self.strProfile = NSUserDefaults.standardUserDefaults().valueForKey("PROFILE_PIC") as? String
        let imgURL: NSURL = NSURL(string: strProfile)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.imgView.image = UIImage(data: data!)
                }
        })
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
