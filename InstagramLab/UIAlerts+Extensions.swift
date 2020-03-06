//
//  UIAlerts+Extensions.swift
//  InstagramLab
//
//  Created by Brendon Cecilio on 3/6/20.
//  Copyright © 2020 Brendon Cecilio. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
