//
//  HomeViewController.swift
//  Gainer
//
//  Created by Ashwin Paudel on 2019-07-22.
//  Copyright © 2020 Ashwin Paudel. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbar = self.tabBar
        tabbar.tintColor = .black
        tabBar.isTranslucent = false
        let controller = self.tabBarController
        controller?.selectedIndex = 1
        tabbar.unselectedItemTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        selectedIndex = 1
        tabbar.selectedImageTintColor = .white
        // Do any additional setup after loading the view.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
