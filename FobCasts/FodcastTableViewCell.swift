//
//  FodcastTableViewCell.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 15/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import SDWebImage

class FodcastTableViewCell: UITableViewCell {

    @IBOutlet weak var fodcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var fodcast: Fodcast! {
        didSet {
            trackNameLabel.text = fodcast.trackName
            artistNameLabel.text = fodcast.artistName
            
            episodeCountLabel.text = "\(fodcast.trackCount ?? 0) Episodes"

            guard let url = URL(string: fodcast.artworkUrl600 ?? "") else { return }

            fodcastImageView.sd_setImage(with: url, completed: nil)
            
            
        }
    }
    
    
}
