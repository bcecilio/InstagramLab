//
//  ProfileCollectionCell.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/9/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    public func updateUI(for item: Item) {
        imageView.kf.setImage(with: URL(fileURLWithPath: item.imageURL))
        captionLabel.text = item.postCaption
    }
}
