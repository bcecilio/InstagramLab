//
//  Item.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/6/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation

struct Item {
    let postName: String
    let postId: String
    let postDate: Date
    let imageURL: String
}

extension Item {
    init(_ dictionary: [String: Any]) {
        self.postName = dictionary["postName"] as? String ?? "no itemName"
        self.postId = dictionary["itemId"] as? String ?? "no itemId"
        self.postDate = dictionary["postDate"] as? Date ?? Date()
        self.imageURL = dictionary["imageURL"] as? String ?? "no imageURL"
    }
}