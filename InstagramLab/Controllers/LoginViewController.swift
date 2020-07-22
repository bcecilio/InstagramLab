//
//  LoginViewController.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/5/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
//    @IBOutlet private var animationView: Lottie.AnimationView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        guard let email = usernameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("missing fields")
            return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    self?.errorLabel.text = "\(error)"
                    self?.errorLabel.textColor = .systemRed
                case .success( _):
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
                case .success( _):
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
    
    @IBAction func toggleLoginToSignUp(_ sender: UIButton) {
        
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        if accountState == .existingUser {
            self.loginButton.setTitle("Login", for: .normal)
            self.signupButton.setTitle("Sign Up", for: .normal)
            self.questionLabel.text = "Don't have an account?"
        } else {
            self.loginButton.setTitle("Sign Up", for: .normal)
            self.signupButton.setTitle("Login", for: .normal)
            self.questionLabel.text = "Already have an account?"
        }
    }
}
