//
//  UserDefaults.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 25/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedFodcastKey = "favoritedFodcastKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    
    func savedFodcasts() -> [Fodcast] {
        guard let saveFodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedFodcastKey) else { return [] }
        guard let savedFodcasts = NSKeyedUnarchiver.unarchiveObject(with: saveFodcastsData) as? [Fodcast] else { return [] }
//        guard let savedFodcasts = NSKeyedUnarchiver.unarchivedObject(ofClass: Fodcast.self, from: saveFodcastsData) as? [Fodcast] else { return [] }
            
        return savedFodcasts
        
    }
    
    func deleteFodcast(fodcast: Fodcast) {
        let fodcasts =  savedFodcasts()
        let filteredFodcasts = fodcasts.filter { (p) -> Bool in
            return p.trackName != fodcast.trackName || (p.trackName == fodcast.trackName && p.artistName != fodcast.artistName)
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredFodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedFodcastKey)
    }
    
    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
//            episodes.append(episode)
            // insert episode at the front of the list
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            
        } catch let encodeErr {
            print("Failed to encode episode: \(encodeErr)")
        }

    }
    
    func downloadedEpisodes() -> [Episode] {
    
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("failed to decode episode: \(decodeErr)")
        }
        
        return []
        
    }
    
    func deleteEpisode(episode: Episode) {
        
        let savedEpisodes = downloadedEpisodes()
        let filteredEpisodes = savedEpisodes.filter { (e) -> Bool in
            
            return e.title != episode.title
            
        }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episode: \(encodeErr)")
        }
        
    }
    
}
