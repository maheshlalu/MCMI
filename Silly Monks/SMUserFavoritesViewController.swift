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
        self.namesArray.removeAll()
        
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return namesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let identifier = "Custom"
        
        var cell: SMFavoritesCell! = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
        
        if cell == nil {
            tableView.registerNib(UINib(nibName: "SMFavoritesCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? SMFavoritesCell
            
            let separatorLineView: UIView = UIView(frame: CGRectMake(0, 0, self.favoritesTableView.frame.size.width, 40))
            /// change size as you need.
            separatorLineView.backgroundColor = UIColor.redColor()
            // you can also put image here
            cell.contentView.addSubview(separatorLineView)
            
        }
        cell.titleLabel.text = self.namesArray[indexPath.row]
        cell?.imageView?.image = UIImage.init(named: imagesArray[indexPath.row])
        print(imagesArray.count)
        
       // cell.titleLabel.text = UIFont(name: ".SFUIText-Regular", size: 11)!
        
        return cell
        
    }
    
       func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
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
