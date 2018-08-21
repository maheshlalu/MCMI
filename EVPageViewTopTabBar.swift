//
//  EVPageViewTopTabBar.swift
//  Pods
//
//  Created by Eric Vennaro on 2/29/16.
//
//
import UIKit

open class EVPageViewTopTabBar: UIView {
    fileprivate let indicatorView = UIView()
    fileprivate let rightButton = UIButton()
    fileprivate let leftButton = UIButton()
    fileprivate var indicatorXPosition = NSLayoutConstraint()
    fileprivate var buttonFontColors: (selectedColor: UIColor, unselectedColor: UIColor)!
    
    open var delegate: EVPageViewTopTabBarDelegate?
    
    open var fontColors: (selectedColor: UIColor, unselectedColor: UIColor)? {
        didSet {
            buttonFontColors = fontColors
            rightButton.setTitleColor(fontColors!.unselectedColor, for: UIControlState())
            leftButton.setTitleColor(fontColors!.selectedColor, for: UIControlState())
        }
    }
    
    open var rightButtonText: String? {
        didSet {
            rightButton.setTitle(rightButtonText, for: UIControlState())
        }
    }
    
    open var leftButtonText: String? {
        didSet {
            leftButton.setTitle(leftButtonText, for: UIControlState())
        }
    }
    
    open var labelFont: UIFont? {
        didSet {
            rightButton.titleLabel?.font = self.labelFont
            leftButton.titleLabel?.font = self.labelFont
        }
    }
    
    open var indicatorViewColor: UIColor? {
        didSet {
            indicatorView.backgroundColor = indicatorViewColor
        }
    }
    
    //MARK: - Initialization
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    open func setupUI() {
        setupRightButton()
        setupLeftButton()
        setupIndicatorView()
        setupGestureRecognizers()
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        self.addSubview(indicatorView)
        
        setConstraints()
    }
    
    internal func leftButtonWasTouched(_ sender: UIButton!) {
        animateLeft()
    }
    
    internal func rightButtonWasTouched(_ sender: UIButton!) {
        animateRight()
    }
    
    internal func respondToRightSwipe(_ gesture: UIGestureRecognizer) {
        animateRight()
    }
    
    internal func respondToLeftSwipe(_ gesture: UIGestureRecognizer) {
        animateLeft()
    }
    
    fileprivate func setupLeftButton() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.addTarget(self, action:#selector(EVPageViewTopTabBar.leftButtonWasTouched(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupRightButton() {
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addTarget(self, action:#selector(EVPageViewTopTabBar.rightButtonWasTouched(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupIndicatorView() {
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.layer.cornerRadius = 4
    }
    
    fileprivate func setupGestureRecognizers() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EVPageViewTopTabBar.respondToRightSwipe(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(EVPageViewTopTabBar.respondToLeftSwipe(_:)))
        
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        
        self.addGestureRecognizer(rightSwipe)
        self.addGestureRecognizer(leftSwipe)
    }
    
    fileprivate func animateRight() {
        if let topBarDelegate = delegate {
            topBarDelegate.willSelectViewControllerAtIndex(1, direction: .forward)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.removeConstraint(self.indicatorXPosition)
                self.indicatorXPosition = NSLayoutConstraint(item: self.indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.rightButton, attribute: .centerX, multiplier: 1, constant: 0)
                self.addConstraint(self.indicatorXPosition)
                self.layoutIfNeeded()
                }, completion: { void in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.rightButton.setTitleColor(self.buttonFontColors.selectedColor, for: UIControlState())
                        self.leftButton.setTitleColor(self.buttonFontColors.unselectedColor, for: UIControlState())
                        }, completion: nil)
            })
        }
    }
    
    fileprivate func animateLeft() {
        if let topBarDelegate = delegate {
            topBarDelegate.willSelectViewControllerAtIndex(0, direction: .reverse)
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.removeConstraint(self.indicatorXPosition)
                self.indicatorXPosition = NSLayoutConstraint(item: self.indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.leftButton, attribute: .centerX, multiplier: 1, constant: 0)
                self.addConstraint(self.indicatorXPosition)
                self.layoutIfNeeded()
                }, completion: { void in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.rightButton.setTitleColor(self.buttonFontColors.unselectedColor, for: UIControlState())
                        self.leftButton.setTitleColor(self.buttonFontColors.selectedColor, for: UIControlState())
                        }, completion: nil)
            })
        }
    }
    
    //MARK: - Set Constraints
    fileprivate func setConstraints() {
        let views = ["leftButton" : leftButton, "indicatorView" : indicatorView, "rightButton" : rightButton]
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[leftButton][indicatorView(==3)]-9-|", options: [], metrics: nil, views: views))
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "[indicatorView(==20)]", options: [], metrics: nil, views: views))
        self.addConstraint(
            NSLayoutConstraint(item: leftButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100))
        indicatorXPosition = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: leftButton, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(indicatorXPosition)
        self.addConstraint(
            NSLayoutConstraint(item: leftButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -70))
        self.addConstraint(
            NSLayoutConstraint(item: rightButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 100))
        self.addConstraint(
            NSLayoutConstraint(item: rightButton, attribute: .leading, relatedBy: .equal, toItem: leftButton, attribute: .trailing, multiplier: 1, constant: 30))
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[rightButton]-12-|", options: [], metrics: nil, views: views))
    }
}

//MARK: - PageViewTopTabBarDelegate
public protocol EVPageViewTopTabBarDelegate {
    func willSelectViewControllerAtIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection)
}
