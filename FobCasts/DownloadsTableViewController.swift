//
//  DownloadsTableViewController.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 26/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class DownloadsTableViewController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    // MARK: - App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
        
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    fileprivate func setupTableView() {
        // use nib of episodeCell
        let nib = UINib(nibName: "EpisodeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Handle Functions
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        guard let index = self.episodes.firstIndex(where: { $0.title == episodeDownloadComplete.episodeTitle }) else { return }
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
        
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        // find the index using title
        guard let index = self.episodes.firstIndex(where: { $0.title == title } ) else { return }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeTableViewCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
}

// MARK: - UITableViewController Datasource

extension DownloadsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeTableViewCell
        cell.episode = self.episodes[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewController Delegate

extension DownloadsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("launch episode player")
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisode: self.episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot file local file, play using stream url instead", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisode: self.episodes)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
}
