//
//  CXProfilePageView.swift
//  Silly Monks
//
//  Created by Mahesh Y on 7/29/16.
//  Copyright © 2016 Sarath. All rights reserved.
//

import UIKit
import EVTopTabBar

class CXProfilePageView: UIViewController, EVTabBar  {
    var pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    var topTabBar: EVPageViewTopTabBar = EVPageViewTopTabBar()
    var subviewControllers: [UIViewController] = []
    var shadowView = UIImageView(image: UIImage(imageLiteral: "filter-background-image"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEVTabBar()
        setupPageView()
        setupConstraints()
       self.title = "Profile"
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupEVTabBar() {
        topTabBar.fontColors = (selectedColor: UIColor.grayColor(), unselectedColor: UIColor.lightGrayColor())
        topTabBar.leftButtonText = "MY PROFILE"
        topTabBar.rightButtonText = "FAVOURITES"
        topTabBar.labelFont = UIFont(name: ".SFUIText-Regular", size: 11)!
        topTabBar.indicatorViewColor = UIColor.orangeColor()
        topTabBar.backgroundColor = UIColor.whiteColor()
        topTabBar.setupUI()
        topTabBar.delegate = self
        let firstVC = SMProfileViewController(nibName:"SMProfileViewController", bundle: nil)
        let secondVC = UserFavoritesViewController(nibName:"UserFavoritesViewController", bundle: nil)
        subviewControllers = [firstVC, secondVC]
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

//MARK: PageViewTopTabBarDelegate
extension CXProfilePageView: EVPageViewTopTabBarDelegate {
    func willSelectViewControllerAtIndex(index: Int, direction: UIPageViewControllerNavigationDirection) {
        pageController.setViewControllers([self.subviewControllers[index]], direction: direction, animated: true, completion: nil)
    }
}