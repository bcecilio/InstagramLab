//
//  FeedCollectionViewCell.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/9/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    private func updateUI(for item: Item) {
        imageVIew.kf.setImage(with: URL(fileURLWithPath: item.imageURL))
        captionLabel.text = item.postCaption
    }
}
