//
//  MainTabBarController.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 14/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = .purple 
   
        setupViewControllers()
        
        setupPlayerDetailsView()
    }
    
    @objc func minimizePlayerDetails() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        }, completion: nil)
        
    }
    
    func maximizePlayerDetails(episode: Episode?, playlistEpisode: [Episode] = []) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        playerDetailsView.playlistEpisode = playlistEpisode

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        }, completion: nil)
    }
    
    // MARK: - Setup functions
    
    let playerDetailsView = PlayerDetailsView.initFromNib()
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    fileprivate func setupPlayerDetailsView() {

        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true

        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        
    }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let favoritesController = FavoritesCollectionViewController(collectionViewLayout: layout)
        viewControllers = [            
            generateNavigationController(with: FodcastsSearchTableViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: favoritesController, title: "Favorite", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: DownloadsTableViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads")),
        ]
        
    }
    
    // MARK: - Helper functions
    
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)

        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
    
        rootViewController.navigationItem.title = title
        
        
        return navController
    }
    
    
}
