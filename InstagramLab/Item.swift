//
//  Item.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/6/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation

struct Item {
    let postCaption: String
    let postId: String
    let imageURL: String
}

extension Item {
    init(_ dictionary: [String: Any]) {
        self.postCaption = dictionary["postName"] as? String ?? "no itemName"
        self.postId = dictionary["itemId"] as? String ?? "no itemId"
        self.imageURL = dictionary["imageURL"] as? String ?? "no imageURL"
    }
}
