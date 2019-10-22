//
//  EpisodeTableViewController.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 15/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import FeedKit

class EpisodeTableViewController: UITableViewController {
    
    var fodcast: Fodcast? {
        didSet {
            navigationItem.title = fodcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        // use FeedKit to parse RSS
        guard let feedUrl = fodcast?.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "cellId"

    var episodes = [Episode]()

    // MARK: - App LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        navigationController?.navigationBar.tintColor = .purple

        setupTableView()
        setupNavigationBarButton()

        
    }
    
    //MARK: - Setup work
    
    fileprivate func setupNavigationBarButton() {
        // check if already saved this fodcast as favorite
        let savedFodcasts = UserDefaults.standard.savedFodcasts()
        let hasFavorited = savedFodcasts.firstIndex(where: { $0.trackName == self.fodcast?.trackName && $0.artistName == self.fodcast?.artistName })
        if  hasFavorited != nil {
            // setting up our heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
            
        }
        
    }

    @objc fileprivate func handleSaveFavorite() {
        print("save userdefaults")

        guard let fodcast = self.fodcast else { return }
        
        // fetch our saved fodcasts first then
        // transform Fodcast into Data
        do {
            var listOfFodcasts = UserDefaults.standard.savedFodcasts()
            listOfFodcasts.append(fodcast)
            let data = try NSKeyedArchiver.archivedData(withRootObject: listOfFodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedFodcastKey)
        } catch let dataErr {
            print(dataErr)
        }
        
        showFavBadgeHighLight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: self, action: #selector(handleCancelSaveFavorite))
        
        
    }
    
    @objc fileprivate func handleCancelSaveFavorite(fodcast: Fodcast) {
        // remove favorite fodcast from EpisodeController
//        UserDefaults.standard.deleteFodcast(fodcast: fodcast)
        // then add function to favorite button again
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    fileprivate func showFavBadgeHighLight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    fileprivate func setupTableView() {
        
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
}

// MARK: - UITableViewController Datasource

extension EpisodeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeTableViewCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        
        return cell
    }

}

// MARK: - UITableViewController Delegate

extension EpisodeTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let activityLabel = UILabel()
        activityLabel.text = "Current loading"
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.textAlignment = .center
        activityLabel.font = UIFont.boldSystemFont(ofSize: 14)
        activityLabel.textColor = .purple
        
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        
        activityIndicatorView.addSubview(activityLabel)
        
        activityLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 8).isActive = true
        activityLabel.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor).isActive = true
        activityLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        activityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisode: self.episodes)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            print("downloadin episode into UserDefaults")
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            self.showDownloadsBadgeHighLight()
            APIService.shared.downloadEpisode(episode: episode)
        }
        
        return [downloadAction]
    }
    
    fileprivate func showDownloadsBadgeHighLight() {
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
    }
    
}

