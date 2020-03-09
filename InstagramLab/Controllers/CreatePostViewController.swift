//
//  CreatePostViewController.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/5/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(showPhotoOption))
        return gesture
    }()
    
    private let dbService = DatabaseService()
    private var postItem: Post
    private let storageService = StorageService()
    private var selectedItemImage: UIImage? {
        didSet {
            uploadImageView.image = selectedItemImage
        }
    }
    
    init?(coder: NSCoder, post: Post) {
        self.postItem = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(longPressGesture)
    }
    
    
    @objc private func showPhotoOption() {
        let alertController = UIAlertController(title: "Choose photo", message: nil, preferredStyle: .actionSheet)
        let camerAction = UIAlertAction(title: "Camera", style: .default) {
            alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "Choose from Library", style: .default) {
            alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(camerAction)
        }
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        guard let postCaption = captionTextView.text, !postCaption.isEmpty, let postImage = selectedItemImage else {
            showAlert(title: "Missing Fields", message: "All fields are required.")
            return
        }
        
        guard let displayName = Auth.auth().currentUser?.displayName else {
            showAlert(title: "Incomplete Profile", message: "Please create a username in your profile settings.")
            return
        }
        
        let resizeImage = UIImage.resizeImage(originalImage: selectedItemImage!, rect: uploadImageView.bounds)
        
        dbService.createItem(postName: postCaption, displayName: displayName, post: postItem) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Error creating post: \(error.localizedDescription)")
                }
            case .success(let documentId):
                self?.uploadPhoto(image: resizeImage, documentId: documentId)
            }
        }
    }
    
    private func uploadPhoto(image: UIImage, documentId: String) {
        storageService.uploadPhoto(itemId: documentId, image: image) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error uploading item", message: "\(error.localizedDescription)")
            case .success(let url):
                self?.updateImageItemURL(url, documentId: documentId)
            }
        }
    }
    
    private func updateImageItemURL(_ url: URL, documentId: String) {
        Firestore.firestore().collection(DatabaseService.postCollection).document(documentId).updateData(["imageURL": url]) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error updating Item", message: "\(error.localizedDescription)")
                }
            }else {
                print("everything updated")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not attain image")
        }
        selectedItemImage = image
    }
}
