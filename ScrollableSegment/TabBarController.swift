//
//  TabBarController.swift
//  ScrollableSegment
//
//  Created by Rita Huang on 2025/1/11.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize tab bar appearance
        tabBar.tintColor = UIColor.darkGray // Change the selected tab's tint color
        tabBar.unselectedItemTintColor = UIColor.gray // Change the unselected tab's tint color

        // Add tab bar icons and titles
        let nvc:UINavigationController = storyboard?.instantiateViewController(withIdentifier: "StockNVC") as! UINavigationController
        let vc = StockViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        nvc.viewControllers = [vc]
        nvc.tabBarItem = UITabBarItem(title: "Stock", image: UIImage(systemName: "star.square"), selectedImage: nil)
        
        let moreVC = UIViewController()
        moreVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "line.3.horizontal"), selectedImage: nil)
        
        viewControllers = [nvc, moreVC]
    }
}
