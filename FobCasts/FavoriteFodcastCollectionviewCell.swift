//
//  FavoriteFodcastCollectionviewCell.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 24/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class FavoriteFodcastCollectionviewCell: UICollectionViewCell {
    
    var fodcast: Fodcast! {
        didSet {
            nameLabel.text = fodcast.trackName
            artistNameLabel.text = fodcast.artistName
            
            let url = URL(string: fodcast.artworkUrl600 ?? "")
            favoriteImageView.sd_setImage(with: url)
        }
    }
    
    let favoriteImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "fodcast name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "artist name"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    fileprivate func setupViews() {
        favoriteImageView.heightAnchor.constraint(equalTo: favoriteImageView.widthAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [favoriteImageView, nameLabel, artistNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
