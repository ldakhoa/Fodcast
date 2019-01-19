//
//  RSSFeed.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 16/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        // blank Episode array
        var episodes = [Episode]()
        
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            // if cannot find image, use the appicon image
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
    
            episodes.append(episode)
        })
        
        return episodes
        
    }
    
}
