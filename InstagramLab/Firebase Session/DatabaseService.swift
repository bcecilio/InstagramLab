//
//  DatabaseService.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/6/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
    
    static let postCollection = "posts"
    
    // reference to the firebase fire store database
    private let database = Firestore.firestore()
    
    public func createItem(postName: String, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let user = Auth.auth().currentUser else {return}
        
        // generate a document id
        let document = database.collection(DatabaseService.postCollection).document()
        
        // create a document un our "items" collection
        database.collection(DatabaseService.postCollection).document(document.documentID).setData(["postName": postName, "displayName": user.uid]) { (error) in
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document.documentID))
            }
        }
    }
}
