//
//  LoginViewController.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/5/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit
import Lottie

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    @IBOutlet private var animationView: Lottie.AnimationView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    private func startAnimation() {
        animationView.animation = Animation.named("16773-fire", subdirectory: nil)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    self?.errorLabel.text = "\(error)"
                    self?.errorLabel.textColor = .systemRed
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorLabel.text = "\(error)"
                        self?.errorLabel.textColor = .systemRed
                    }
                case .success(let newUser):
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "Main", viewControllerId: "MainTabBarController")
    }
    
    private func clearErrorLabel() {
        errorLabel.text = ""
    }
    
    
}
