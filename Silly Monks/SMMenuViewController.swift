//
//  SMMenuViewController.swift
//  Silly Monks
//
//  Created by Sarath on 21/03/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit

public class SMMenuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var selectedMenuItem : Int = 0
    var homeBtn : UIButton = UIButton()
    var menuTableView : UITableView = UITableView()
    var menuItemsArray:NSMutableArray = NSMutableArray()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 0.6)
        //self.getSideMenuItems()
        self.menuItemsArray = CXConstant.getSideMenuItems()
        self.customizeView()
        
    }
    
//    func getSideMenuItems() {
//        for menuItem in (CXDBSettings.sharedInstance.getAllMallsInDB().valueForKeyPath("name") as? NSArray)!{
//          let category = menuItem.stringByReplacingOccurrencesOfString("Silly Monks", withString: "")
//            self.menuItemsArray.addObject((category.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())))
//            print(self.menuItemsArray)
//        }
//    }

    func customizeView() {
       /* let prjTitle = UILabel(frame: CGRectMake(20, 80,140,50))//CGRectMake(20, 80,140,50)
        //prjTitle.backgroundColor = UIColor.yellowColor()
        prjTitle.textAlignment = NSTextAlignment.Right
        prjTitle.font = UIFont(name: "RobotoCondensed-Bold", size: 25)
        prjTitle.textColor = UIColor.blackColor()
        prjTitle.text = "SILLY MONKS"
        self.view.addSubview(prjTitle)
        
        let lImageView = UIImageView(frame: CGRectMake(prjTitle.frame.size.width + prjTitle.frame.origin.x, prjTitle.frame.origin.y, 50, 50))
        lImageView.image = UIImage(named: "smlogo.png")
        self.view.addSubview(lImageView);*/
        
        let profileImage = UIImageView.init(frame: CGRectMake(20,80,200,40))
        profileImage.image = UIImage(named:"sm_navigation_logo")
        profileImage.contentMode = UIViewContentMode.ScaleAspectFit
        profileImage.backgroundColor = UIColor.clearColor()
        self.view.addSubview(profileImage)
        
        self.homeBtn = UIButton(type: UIButtonType.Custom)
        self.homeBtn.backgroundColor = UIColor.clearColor()
        self.homeBtn.frame = CGRectMake(5, profileImage.frame.size.height+profileImage.frame.origin.y+10,220, 50)
        self.homeBtn.setTitle("Home", forState: .Normal)
        self.homeBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.homeBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 18)
        self.homeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -150, 0, 0)
        self.homeBtn.addTarget(self, action: #selector(SMMenuViewController.homeBtnAction), forControlEvents: .TouchUpInside)
        let hImage = UIImage(named: "smhome_icon.png")
        let hImgView = UIImageView(frame: CGRectMake(self.homeBtn.frame.size.width-31,12, 26, 26))
        hImgView.image = hImage
        hImgView.userInteractionEnabled = true
        self.homeBtn.addSubview(hImgView)
        
        self.view.addSubview(homeBtn)
        
        self.customizeTableView()
    }
    
    func homeBtnAction() {
        sideMenuController()?.sideMenu?.homeBtnTapped()
        //self.navigationController?.popViewControllerAnimated(true)
        
    }
    func customizeTableView(){
        let yPos = self.homeBtn.frame.size.height+self.homeBtn.frame.origin.y+5
        self.menuTableView = UITableView(frame: CGRectMake(0, yPos, 230, self.view.frame.size.height - yPos - 80))
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.tableFooterView = UIView()
        self.menuTableView.scrollEnabled = false
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.menuTableView.separatorColor = UIColor.blackColor()
        self.menuTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(menuTableView)
        
        let powerLbl = UILabel.init(frame: CGRectMake(10, self.menuTableView.frame.size.height+self.menuTableView.frame.origin.y, 80, 35))
        powerLbl.text = "Powered by"
        powerLbl.textColor = UIColor.grayColor()
        powerLbl.font = UIFont(name:"Roboto-Regular",size: 14)
        self.view.addSubview(powerLbl)
        
        let logoImage = UIImageView.init(frame: CGRectMake(powerLbl.frame.size.width+powerLbl.frame.origin.x+5, powerLbl.frame.origin.y-10, 120, 50))
        logoImage.image = UIImage(named: "storeongo_gray.png")
        self.view.addSubview(logoImage)
    }
    
    func updateItems() {
        self.menuItemsArray = CXConstant.getSideMenuItems()
       // print("Menu Items Update \(self.menuItemsArray)")
        self.menuTableView.reloadData()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsArray.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") ?? UITableViewCell(style: .Default, reuseIdentifier: "CellID")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = self.menuItemsArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont(name: "Roboto-Regular", size: 17)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // print("did select row: \(indexPath.row)")
        if (indexPath.row == selectedMenuItem) {
//            return
        }
        selectedMenuItem = indexPath.row
        sideMenuController()?.sideMenu?.selectedIndex = indexPath.row
        sideMenuController()?.sideMenu?.toggleMenu()
        
        
//        var destViewController : UIViewController
//        switch (indexPath.row) {
//        case 0:
//            destViewController =
//            break
//        case 1:
//            destViewController =
//            break
//        case 2:
//            destViewController =
//            break
//        default:
//            destViewController =
//            break
//        }
//        sideMenuController()?.setContentViewController(destViewController)
    }

    
    
    
    override public func didReceiveMemoryWarning() {
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
