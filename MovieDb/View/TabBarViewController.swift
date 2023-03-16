//
//  TabBarViewController.swift
//  MovieDb
//
//  Created by Haris Fadhilah on 15/03/23.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let movieVC = UINavigationController(rootViewController: ViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        
        movieVC.title = "Home"
        searchVC.title = "Search"
        
        self.setViewControllers([movieVC, searchVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let imagesItem = ["film", "magnifyingglass"]
        
        for item in 0...1 {
            items[item].image = UIImage(systemName: imagesItem[item])
        }
        
    }
    
}
