//
//  Episode.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 16/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import Foundation
import FeedKit

struct Episode: Codable {
    
    let title: String
    let pubDate: Date
    let description: String
    let author: String
    var imageUrl: String?
    let streamUrl: String
    var fileUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
}
