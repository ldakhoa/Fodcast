//
//  FodcastsSearchTableViewController.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 14/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class FodcastsSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    fileprivate let cellId = "cellId"
    
    var fodcasts = [Fodcast]()

    let searchController = UISearchController(searchResultsController: nil)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()

    }
    
    // MARK: - Setup Work
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        searchController.searchBar.placeholder = "All Fodcasts"
        searchController.searchBar.tintColor = .purple
    }
    
    fileprivate func setupTableView() {
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "FodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // delay 0.5s after search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            // implement Alamofire to search iTunes API
            APIService.shared.fetchFodcasts(searchText: searchText) { (fodcasts) in
                self.fodcasts = fodcasts
                self.tableView.reloadData()
            }
        })

    }

}

// MARK: - UITableViewController Datasource

extension FodcastsSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fodcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FodcastTableViewCell
        
        let fodcast = self.fodcasts[indexPath.row]
        cell.fodcast = fodcast
        
        return cell
    }

}

// MARK: - UITableViewController Delegate

extension FodcastsSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.fodcasts.count > 0 ? 0 : 300
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodeController = EpisodeTableViewController()
        let fodcast = self.fodcasts[indexPath.row]
        
        episodeController.fodcast = fodcast
        navigationController?.pushViewController(episodeController, animated: true)
    }
}
