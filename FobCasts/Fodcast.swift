//
//  Fodcast.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 14/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import Foundation

class Fodcast: NSObject ,Decodable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        print("trying to transform fodcast into data")
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        aCoder.encode(feedUrl ?? "", forKey: "feedKey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("trying to turn data into fodcast")
        self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedKey") as? String
    }
    
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
    
}
