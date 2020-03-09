//
//  ViewController.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/5/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var listener: ListenerRegistration?
    
//    private var items = [Item]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        listener = Firestore.firestore().collection(DatabaseService.postCollection).addSnapshotListener({ [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Try again later", message: "firestore error: \(error)")
                }
            } else if let snapshot = snapshot { // this is the data in our firebase database
                let items = snapshot.documents.map { Item($0.data()) }
//                self?.items = items
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listener?.remove()
    }
}

