//
//  UserFavoritesViewController.swift
//  SMSample
//
//  Created by CX_One on 7/28/16.
//  Copyright © 2016 CX_One. All rights reserved.
//

import UIKit

class UserFavoritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var namesArray = ["Eega Full Movie","Dikkulu Choodaku Ramayya Full Movie","Oohalu Gusagusalade Full Movie","Paatshala Full Movie"]
    
    var imagesArray = ["eega.jpg","Dikkulu_Choodaku_Ramayya.jpg","Oohalu Gusagusalade.jpg","paatshala.jpeg"]
    
    var detailArray = ["fgjyfguyweguyfgefgjdvkjfdhvkdhjhfiji","jwqgiuyEIYETRFGUDUDYFHGIERUTOUUROUT","hjfdurhyfuiehrfijvmnckjhfdhflsdjsl"]
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self;
        favoritesTableView.dataSource = self;
        favoritesTableView.separatorStyle = .None

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return namesArray.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        
        return 15.0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let identifier = "Custom"
        
        var cell: SMFavoritesCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SMFavoritesCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
        }
        cell.titleLabel.text = self.namesArray[indexPath.section]
        cell?.imageView?.image = UIImage.init(named: imagesArray[indexPath.section])
        print(imagesArray.count)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80.0;//Choose your custom row height
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            //delete functionality
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
