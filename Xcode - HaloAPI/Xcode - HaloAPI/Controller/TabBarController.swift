//
//  TabBarController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 19/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        self.selectedIndex = 0
        setNavigationBarTitle()
        
        
        HaloApiInterface.sharedInstance.fetchEmblemImage(param: ["size" : 95]) { (logoImage) in
            let playerLogo : UIBarButtonItem = UIBarButtonItem()
            playerLogo.image = logoImage.withRenderingMode(.alwaysOriginal)
            
            self.navigationItem.rightBarButtonItem = playerLogo
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func setNavigationBarTitle(){
        self.title = self.tabBar.items![self.selectedIndex].title
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        setNavigationBarTitle()
    }
}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.0, y: 1.0)
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.transform = .identity
        }, completion: { transitionContext.completeTransition($0) })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
