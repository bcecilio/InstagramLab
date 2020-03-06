//
//  ProfileViewController.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/5/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profileImage.image = selectedImage
        }
    }
    
    private let storageService = StorageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        usernameLabel.text = user.email
        profileImage.kf.setImage(with: user.photoURL)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Profile Picture", message: nil, preferredStyle: .actionSheet)
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
    
    @IBAction func updateProfileButtonPressed(_ sender: UIButton) {
    guard let displayName = usernameLabel.text, !displayName.isEmpty, let selectedImage = selectedImage else {
        print("missing fields")
        return
    }
    
    guard let user = Auth.auth().currentUser else {return}
    
    let resizeImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImage.bounds)
    
    print("original image size: \(selectedImage.size)")
    print("original image size: \(resizeImage)")
    
    storageService.uploadPhoto(userId: user.uid, image: resizeImage) { [weak self] (result) in
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self?.showAlert(title: "Error", message: "Error uploading photo: \(error.localizedDescription)")
            }
        case .success(let url):
            let request = Auth.auth().currentUser?.createProfileChangeRequest()
            request?.photoURL = url
            request?.displayName = displayName
            request?.commitChanges(completion: { [unowned self] (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Could not change display name", message: "Error changing display name: \(error.localizedDescription)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Success!", message: "Your display name has changed successfully.")
                    }
                }
            })
        }
    }
}
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "Login", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        dismiss(animated: true)
    }
}
