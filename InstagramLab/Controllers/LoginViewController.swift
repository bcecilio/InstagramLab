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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func startAnimation() {
        animationView.animation = Animation.named("16773-fire", subdirectory: nil)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
    }
}
