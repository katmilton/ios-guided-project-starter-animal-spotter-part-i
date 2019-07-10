//
//  LoginViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signInButton: UIButton!
    
    var apiController: APIController?
    var loginType = LoginType.signUp

    override func viewDidLoad() {
        super.viewDidLoad()

        // customize button appearance
    }
    
    // MARK: - Action Handlers
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // perform login or sign up operation based on loginType via segmented control
        // Get the username and password from the text fields.
        
        if let username = usernameTextField.text,
            !username.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty {
            
            let user = User(username: username, password: password)
            
            switch loginType {
            case .signUp:
                signUp(with: user)
            case .signIn:
                signIn(with: user)
            }
        }
        
    }
    
    @IBAction func signInTypeChanged(_ sender: UISegmentedControl) {
        // switch UI between modes
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }
        
        
    }
    
    private func signUp(with user: User) {
        apiController?.signUp(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error during signup process: \(error)")
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sign up successful!", message: "Now please sign in.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: {
                        self.loginType = .signIn
                        self.loginTypeSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
                    })
                }
            }
        })
    }
    
    
    private func signIn(with user: User) {
        apiController?.signIn(with: user, completion: { (error) in
            if let error = error {
                NSLog("Error occurred during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    
}
