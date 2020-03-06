//
//  StorageService.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/6/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    private let storageRef = Storage.storage().reference()
    
    public func uploadPhoto(userId: String? = nil, itemId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        var photoReference: StorageReference!
        if let userId = userId { // coming from profileViewController
            photoReference = storageRef.child("UserProfilePhotos/\(userId).jpg")
        } else if let itemId = itemId { // coming from createItemViewController
            photoReference = storageRef.child("ItemsPhotos/\(itemId).jpg")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
}
