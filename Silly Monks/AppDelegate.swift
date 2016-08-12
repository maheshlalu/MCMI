//
//  AppDelegate.swift
//  Silly Monks
//
//  Created by Sarath on 16/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import FBSDKCoreKit
import MagicalRecord
import Fabric
import mopub_ios_sdk

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?
    var restrictRotation: Bool = true
    var splashImageView: UIImageView!

   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //self.window?.backgroundColor = UIColor.yellowColor()
        //NSThread.sleepForTimeInterval(10)
        
        
        self.setUpMagicalDB()
        self.setupMopupbs()
        self.configure()

        let wFrame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window = UIWindow.init(frame: wFrame)
        if !NSUserDefaults.standardUserDefaults().boolForKey("FIRST_TIME_LOGIN"){
            let signUpView = CXSignInSignUpViewController.init()
            let  navController: UINavigationController = UINavigationController(rootViewController: signUpView)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }else{
        let homeView = HomeViewController.init()
        let sideMenu = SMMenuViewController.init()
        let  navController: SMNavigationController = SMNavigationController(menuViewController: sideMenu,contentViewController: homeView)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        }
        
        
        
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var categoryError :NSError?
            var success: Bool
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                success = true
            } catch let error as NSError {
                categoryError = error
                success = false
            }
            
            if !success {
                print("AppDelegate Debug - Error setting AVAudioSession category.  Because of this, there may be no sound. \(categoryError!)")
            }
            
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            var configureError: NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
            
            GIDSignIn.sharedInstance().delegate = self
            
//            dispatch_async(dispatch_get_main_queue(), {
//                //Update UI
//                });
       // }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //Do background work
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //Update UI
//                });
//            });

        
        
        
        
       
//        self.splashImageView = UIImageView.init(frame: wFrame)
//        let url = NSBundle.mainBundle().URLForResource("silly", withExtension: "gif")
//        self.splashImageView.image = UIImage.animatedImageWithAnimatedGIFURL(url!)
//        self.window?.addSubview(self.splashImageView)
//        
//        self.performSelector(#selector(AppDelegate.moveToHomeView), withObject: self, afterDelay: 4)
        
        
        print("Path is \(NSPersistentStore.MR_urlForStoreName(MagicalRecord.defaultStoreName()))")
        
       //[NSPersistentStore MR_urlForStoreName:[MagicalRecord defaultStoreName]]
        
        return true
    }
    
    func setupMopupbs(){
        Fabric.with([MoPub.self])
    }
    
    func setUpMagicalDB() {
        //MagicalRecord.setupCoreDataStackWithStoreNamed("Silly_Monks")
        NSPersistentStoreCoordinator.MR_setDefaultStoreCoordinator(persistentStoreCoordinator)
        NSManagedObjectContext.MR_initializeDefaultContextWithCoordinator(persistentStoreCoordinator)
    }
    
//    func moveToHomeView() {
//        self.splashImageView.hidden = true
//    }
    
    
    
    /*
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
             GIDSignIn.sharedInstance().hasAuthInKeychain()
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
           // let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            let profilePic = user.profile.imageURLWithDimension(150)

           
            let url = NSURL(string:  "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken)")
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url!) {(data, response, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                do {
                    let userData = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String:AnyObject]
                    /*
                     Get the account information you want here from the dictionary
                     Possible values are
                     "id": "...",
                     "email": "...",
                     "verified_email": ...,
                     "name": "...",
                     "given_name": "...",
                     "family_name": "...",
                     "link": "https://plus.google.com/...",
                     "picture": "https://lh5.googleuserco...",
                     "gender": "...",
                     "locale": "..."
                     
                     so in my case:
                     */
                    let gender = userData!["gender"] as! String
                    
                } catch {
                    NSLog("Account Information could not be loaded")
                }
            }

            
           // print("User id \(user.userID) pro name \(user.profile.name)")
            
//            let fullNamesArray:NSArray = fullName.componentsSeparatedByString(" ")
//            let firstName = fullNamesArray.objectAtIndex(0)
//            let lastName = fullNamesArray.objectAtIndex(1)
//            NSLog("gender: %@", gender)
            
            /* NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "USER_ID")
             NSUserDefaults.standardUserDefaults().setObject(email, forKey: "USER_EMAIL")
             NSUserDefaults.standardUserDefaults().setObject(strFirstName, forKey: "FIRST_NAME")
             NSUserDefaults.standardUserDefaults().setObject(strLastName, forKey: "LAST_NAME")
             NSUserDefaults.standardUserDefaults().setObject(gender, forKey: "GENDER")
             NSUserDefaults.standardUserDefaults().setObject(self.profileImageStr, forKey: "PROFILE_PIC")*/
            
           /*
            NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "USER_ID")
            NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "FIRST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "LAST_NAME")
            NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "GENDER")
            NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "PROFILE_PIC")
            NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "USER_EMAIL")
            NSUserDefaults.standardUserDefaults().synchronize()
            */
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

 
    */

    
    

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            var firstName = ""
            var lastName = ""
            let userId = user.userID
            var gender = ""
            var profilePic = ""
            var email = ""
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let url = NSURL(string:  "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(user.authentication.accessToken)")
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(url!) {(data, response, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                do {
                    let userData = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String:AnyObject]

                    firstName = userData!["given_name"] as! String
                    lastName = userData!["family_name"] as! String
                    gender = userData!["gender"] as! String
                    profilePic = userData!["picture"] as! String
                    email = userData!["email"] as! String
   
                    NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "USER_ID")
                    NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "FIRST_NAME")
                    NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "LAST_NAME")
                    NSUserDefaults.standardUserDefaults().setObject(gender, forKey: "GENDER")
                    NSUserDefaults.standardUserDefaults().setObject(profilePic, forKey: "PROFILE_PIC")
                    NSUserDefaults.standardUserDefaults().setObject(email, forKey: "USER_EMAIL")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                } catch {
                    NSLog("Account Information could not be loaded")
                }
                
                }.resume()
        }
            
        else {
            //Login Failed
            NSLog("login failed")
            
        }
    }
    
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
      //  self.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let callBack:Bool
       // print("***************************url Schemaaa:", url.scheme);
        
        if url.scheme == "fb278005239212205" {
            callBack = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            callBack = GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return callBack
    }
    
    
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        if self.restrictRotation == true {
//            return UIInterfaceOrientationMask.Portrait
//        } else {
//            return UIInterfaceOrientationMask.All
//        }
//    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        let deviceOrientation = UIDevice.currentDevice().orientation
        if self.restrictRotation == true {
            return UIInterfaceOrientationMask.Portrait
        } else {
            return UIInterfaceOrientationMask.Landscape
        }
    }

    
     func shouldAutorotate() -> Bool {
        switch UIDevice.currentDevice().orientation {
        case .Portrait, .PortraitUpsideDown, .Unknown:
            return true
        default:
            return false
        }
    }
        
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
        return UIInterfaceOrientationMask.All
    }

    
    
    
     func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {8
        return UIInterfaceOrientation.LandscapeLeft;
    }

    
    

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.taras.Silly_Monks" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Silly_Monks", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Sillymonks.sqlite")
        print("Path is \(url)")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let dispatch = dispatch_get_main_queue()
        dispatch_async(dispatch) { () -> Void in
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion({ (Bool, error) -> Void in
                //TODO: do something when function finish
            })
        }
    }
    
    //MARK: Loader configuration

    func configure (){
        var config : LoadingView.Config = LoadingView.Config()
        config.size = 100
        config.backgroundColor = UIColor.blackColor() //UIColor(red:0.03, green:0.82, blue:0.7, alpha:1)
        config.spinnerColor = UIColor.whiteColor()//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.titleTextColor = UIColor.whiteColor()//UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.5
        LoadingView.setConfig(config)
    }
}

