//
//  SMMenuViewController.swift
//  Silly Monks
//
//  Created by Sarath on 21/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit


open class SMMenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,CXSingInDelegate{

    var selectedMenuItem : Int = 0
    var homeBtn : UIButton = UIButton()
    var menuTableView : UITableView = UITableView()
    var menuItemsArray:NSMutableArray = NSMutableArray()
    var productCategoryArray:NSMutableArray = NSMutableArray()

    var strProfile: String!
    
    
    //Change
    var profileDPImageView:UIImageView!
    var sidePanelView:UIView!
    var signInBtn:UIButton!
    var aboutUsBtn:UIButton!
    var profileBtn:UIButton!
    var termsConditionsBtn:UIButton!
    var contactUsBtn:UIButton!
    var advertiseBtn:UIButton!
    var shareAppBtn:UIButton!
    var fbButton:UIButton!
    var twitterButton:UIButton!
    var googlePlusButton:UIButton!
      var transparentView:UIView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //         self.customizeSidePanelView()
        self.view.backgroundColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 0.6)
        //        self.getSideMenuItems()
        self.menuItemsArray = CXConstant.getSideMenuItems()
        self.menuItemsArray = ["Sign In","About SMT","Contact Us"];//"Terms & Conditions",
        
        self.customizeView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SMMenuViewController.backAction), name: NSNotification.Name(rawValue: "BackAction"), object: nil)
        //NotificationCenter.default.addObserver(self, selector:Selector(profileUpdateNotif()), name: "UpdateProfilePic", object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SMMenuViewController.logoutNotification(_:)), name:NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SMMenuViewController.initialUpdate(_:)), name:NSNotification.Name(rawValue: "InitialUpdateMenuItems"), object: nil)
        self.profileUpdateNotif()
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        let mailID = UserDefaults.standard.value(forKey: "USER_EMAIL")
        if mailID == nil
        {
            //self.profileUpdateNotif()
        }
    
    }
    func initialUpdate(_ notification: Notification) {
        
        self.profileUpdateNotif()
    }
    
    func backAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func logoutNotification(_ notification: Notification){

        if UserDefaults.standard.value(forKey: "PROFILE_PIC") != nil {
            self.strProfile = UserDefaults.standard.value(forKey: "PROFILE_PIC") as? String
            let imgURL: URL = URL(string: strProfile)!
            let request: URLRequest = URLRequest(url: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: OperationQueue.main,
                completionHandler: {(response: URLResponse?,data: Data?,error: NSError?) -> Void in
                    if error == nil {
                        self.profileDPImageView.image = UIImage(data: data!)
                    }
            } as! (URLResponse?, Data?, Error?) -> Void)
        } else {
            self.profileDPImageView.image = UIImage(named: "profile_placeholder.png")
        }
        self.updateItems()

    }
    

    func customizeView() {

        
        let profileImage = UIImageView.init(frame: CGRect(x: 20,y: 80,width: 200,height: 40))
        profileImage.image = UIImage(named:"sm_navigation_logo")
        profileImage.contentMode = UIViewContentMode.scaleAspectFit
        profileImage.backgroundColor = UIColor.clear
//        self.view.addSubview(profileImage)
        
        self.homeBtn = UIButton(type: UIButtonType.custom)
        self.homeBtn.backgroundColor = UIColor.clear
        self.homeBtn.frame = CGRect(x: 5, y: profileImage.frame.size.height+profileImage.frame.origin.y+10,width: 220, height: 50)
        self.homeBtn.setTitle("Home", for: UIControlState())
        self.homeBtn.setTitleColor(UIColor.black, for: UIControlState())
        self.homeBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
        self.homeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0)
        self.homeBtn.addTarget(self, action: #selector(SMMenuViewController.homeBtnAction), for: .touchUpInside)
        let hImage = UIImage(named: "smhome_icon.png")
        let hImgView = UIImageView(frame: CGRect(x: self.homeBtn.frame.size.width-31,y: 12, width: 26, height: 26))
        hImgView.image = hImage
        hImgView.isUserInteractionEnabled = true
        self.homeBtn.addSubview(hImgView)
        
                let profileImage1 = UIImageView.init(frame: CGRect(x: 20,y: 80,width: 200,height: 40))
                profileImage1.image = UIImage(named:"SMT_Logo")
                profileImage1.layer.cornerRadius = 25
                profileImage1.layer.masksToBounds = true
                //        self.sidePanelView.addSubview(profileImage)
        
                self.profileDPImageView = UIImageView.init(frame: CGRect(x: 55,y: 70,width: 110,height: 110))
                self.profileDPImageView .image = UIImage(named: "profile_placeholder.png")
                self.profileDPImageView .layer.cornerRadius = self.profileDPImageView.frame.size.width / 2
                self.profileDPImageView .clipsToBounds = true
                self.profileDPImageView.isUserInteractionEnabled = true
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
                self.profileDPImageView.addGestureRecognizer(tapRecognizer)

        self.view.addSubview(profileDPImageView)
       self.customizeTableView()
    }
    
    func profileUpdateNotif(){
        //  self.profileBtn
        self.updateItems()
        if UserDefaults.standard.value(forKey: "PROFILE_PIC") != nil {
            self.strProfile = UserDefaults.standard.value(forKey: "PROFILE_PIC") as? String
            let imgURL: URL = URL(string: strProfile)!
            let request: URLRequest = URLRequest(url: imgURL)
            NSURLConnection.sendAsynchronousRequest(
                request, queue: OperationQueue.main,
                completionHandler: {(response: URLResponse?,data: Data?,error: NSError?) -> Void in
                    if error == nil {
                        self.profileDPImageView.image = UIImage(data: data!)
                    }
            } as! (URLResponse?, Data?, Error?) -> Void)
        } else {
            self.profileDPImageView.image = UIImage(named: "profile_placeholder.png")
        }
    }

    
    func profileImageClicked() {
        let profile : UIViewController
        if UserDefaults.standard.value(forKey: "USER_ID") != nil {
            NSLog("it has an userid")
           //  profile = CXProfilePageView.init()
            profile = SMProfileViewController(nibName:"SMProfileViewController", bundle: nil)

            
        } else {
            profile = CXSignInSignUpViewController()
            
        }
        let nav = UIApplication.shared.windows[0].rootViewController as! UINavigationController
        nav.navigationBar.tintColor = UIColor.white
        
        nav.pushViewController(profile, animated: true)
//        sideMenuController()?.setContentViewController(profile)
        sideMenuController()?.sideMenu?.hideSideMenu()
    }
    
    func createButton(_ frame:CGRect,title: String,tag:Int, bgColor:UIColor) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name:"Roboto-Regular", size: 18)
        button.titleLabel?.textAlignment = NSTextAlignment.left
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.backgroundColor = bgColor
        return button
    }
    
    func createImageButton(_ frame:CGRect,tag:Int,bImage:UIImage) -> UIButton {
        let button: UIButton = UIButton()
        button.frame = frame
        button.backgroundColor = UIColor.yellow
        button.setImage(bImage, for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        return button
    }
    
    func customizeSidePanelView() {
        self.transparentView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.transparentView.backgroundColor = UIColor.black
        self.transparentView.alpha = 0.4
        self.view.addSubview(self.transparentView)
        self.transparentView.isHidden = true
        self.sidePanelView = UIView.init(frame: CGRect(x: -250, y: 0, width: 250, height: self.view.frame.size.height))
        self.sidePanelView.backgroundColor = UIColor.smBackgroundColor()
        self.sidePanelView.alpha = 0.95
        self.customizeView()
    }



    
    func homeBtnAction() {
        sideMenuController()?.sideMenu?.homeBtnTapped()
        //self.navigationController?.popViewControllerAnimated(true)
        
    }
    func customizeTableView(){
        let yPos = self.homeBtn.frame.size.height+self.homeBtn.frame.origin.y+5
        self.menuTableView = UITableView(frame: CGRect(x: 0, y: yPos, width: 230, height: self.view.frame.size.height - yPos - 130))
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.tableFooterView = UIView()
        self.menuTableView.isScrollEnabled = true
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.menuTableView.separatorColor = UIColor.black
        self.menuTableView.backgroundColor = UIColor.clear
        self.view.addSubview(menuTableView)
        
        let shareBtn = UIButton.init(frame: CGRect(x: 25, y: yPos+self.menuTableView.frame.size.height+5, width: 150, height: 35))
        shareBtn.backgroundColor = UIColor.init(colorLiteralRed: 71/255, green: 47/255, blue: 150/255, alpha: 1)
        shareBtn.setTitle("Share This App", for: UIControlState())
        shareBtn.setTitleColor(UIColor.white, for: UIControlState())
        shareBtn.titleLabel?.font = UIFont.init(name: "Roboto-Regular", size: 15)
        shareBtn.layer.cornerRadius = 10
        shareBtn.clipsToBounds = true
        shareBtn.addTarget(self, action: #selector(SMMenuViewController.shareThisAppBtnAction), for: .touchUpInside)
        self.view.addSubview(shareBtn)
        
        
        
        let powerLbl = UILabel.init(frame: CGRect(x: 10, y: self.menuTableView.frame.size.height+self.menuTableView.frame.origin.y+60, width: 80, height: 35))
        powerLbl.text = "Powered by"
        powerLbl.textColor = UIColor.gray
        powerLbl.font = UIFont(name:"Roboto-Regular",size: 14)
        self.view.addSubview(powerLbl)
        
        let logoImage = UIImageView.init(frame: CGRect(x: powerLbl.frame.size.width+powerLbl.frame.origin.x+5, y: powerLbl.frame.origin.y-10, width: 120, height: 50))
        logoImage.image = UIImage(named: "storeongo_gray.png")
        self.view.addSubview(logoImage)
    }
    
    func shareThisAppBtnAction()
    {
        let infoText = CXConstant.appStoreUrl
        
        let shareItems:Array = [infoText]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    func getUserID() ->String{
        
        // print(NSUserDefaults.standardUserDefaults().valueForKey("USER_ID"))
        if(UserDefaults.standard.value(forKey: "USER_ID") == nil)
        {
            print("NULL")
            return ""
            
        }else{
            guard let userId = UserDefaults.standard.value(forKey: "USER_ID") else {
                return ""
            }
            let number = CXConstant.resultString((userId as? AnyObject)!)
            return number
        }
    }
    
    
    func updateItems() {
        self.menuItemsArray = NSMutableArray()
        
        let list : NSArray = self.getAllProductCategoriesFromDB(CXConstant.MALL_ID)
        self.productCategoryArray = NSMutableArray(array: list)
        //USER_ID
        if self.getUserID().isEmpty {
            self.menuItemsArray = ["Sign In","About SMT","Contact Us"]//"Terms & Conditions",
            
        }else{
            self.menuItemsArray = ["Profile","About SMT","Contact Us"] //"Terms & Conditions",
            
        }
        
        for category in list {
            let allMalls : CX_Product_Category = category as! CX_Product_Category
            self.menuItemsArray.add(allMalls.name!)
            
        }
        
        // print("Menu Items Update \(self.menuItemsArray)")
        self.menuTableView.reloadData()
    }
    
    func getAllProductCategoriesFromDB(_ mallID:String) -> NSMutableArray {
        let predicate: NSPredicate = NSPredicate(format: "createdById = %@", mallID)
        
        //let fetchRequest = CX_Product_Category.MR_requestAllSortedBy("pid", ascending: true)
        // let fetchRequest = NSFetchRequest(entityName: "CX_Product_Category")
        let fetchRequest = CX_Product_Category.mr_requestAllSorted(by: "pid", ascending: false) //NSFetchRequest(entityName: "CX_Products") //
        
        fetchRequest?.predicate = predicate
        //fetchRequest.entity = productEn
        // self.productCategories =   CX_Product_Category.MR_executeFetchRequest(fetchRequest)
        let productCatList :NSArray = CX_Product_Category.mr_executeFetchRequest(fetchRequest) as! NSArray
        let proKatList : NSMutableArray = NSMutableArray(array: productCatList)
        return proKatList
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsArray.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") ?? UITableViewCell(style: .default, reuseIdentifier: "CellID")
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = self.menuItemsArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("did select row: \(indexPath.row)")
        if (indexPath.row == selectedMenuItem) {
//            return
        }
        selectedMenuItem = indexPath.row
        sideMenuController()?.sideMenu?.selectedIndex = indexPath.row
        sideMenuController()?.sideMenu?.toggleMenu()
        
        
        var destViewController = UIViewController()
        switch (indexPath.row) {
        case 0:
            let str = self.menuItemsArray[indexPath.row]
            if  (str as AnyObject).isEqual(to: "Profile") {
                //destViewController = CXProfilePageView()
                destViewController = SMProfileViewController(nibName:"SMProfileViewController", bundle: nil)

            }
            else {
                let viewController : CXSignInSignUpViewController = CXSignInSignUpViewController()
                viewController.delegate = self
                destViewController = viewController;
            }
            
            break
        case 1:
            destViewController = CXAboutUsViewController()
            break
//        case 2:
//            destViewController = CXTermsAndConditionsViewController()
//            break
        case 2:
            destViewController = CXContactUsViewController()
            break
       /* case 3:
            let prodCategory:CX_Product_Category = self.productCategoryArray[indexPath.row-3] as! CX_Product_Category
            let productsView = CXProductsViewController.init()
            productsView.productCategory = prodCategory
            self.navigationController?.pushViewController(productsView, animated: true)
            destViewController =  productsView
           // destViewController = CXAdvertiseViewController()
            break*/
        default:
//            destViewController = CXAdvertiseViewController()
            let prodCategory:CX_Product_Category = self.productCategoryArray[indexPath.row-3] as! CX_Product_Category
            let productsView = CXProductsViewController.init()
            productsView.productCategory = prodCategory
            self.navigationController?.pushViewController(productsView, animated: true)
            destViewController =  productsView
            // destViewController = CXAdvertiseViewController()
            break
        }
        
        let nav = UIApplication.shared.windows[0].rootViewController as! UINavigationController
        
        nav.pushViewController(destViewController, animated: true)
//        sideMenuController()?.sideMenu?.hideSideMenu()
    }

    func didGoogleSignIn(){
      
        self.profileUpdateNotif()
        
        
    }
    
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
