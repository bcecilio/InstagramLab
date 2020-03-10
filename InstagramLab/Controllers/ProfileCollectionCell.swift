//
//  ProfileCollectionCell.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/9/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class ProfileCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    public func updateUI(for item: Item) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        userImageView.kf.setImage(with: user.photoURL)
        usernameLabel.text = user.email
        imageView.kf.setImage(with: URL(fileURLWithPath: item.imageURL))
        captionLabel.text = item.postCaption
    }
}
