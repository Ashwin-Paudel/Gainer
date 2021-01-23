//
//  ViewController.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-15.
//

import FirebaseAuth
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // We need to do a check if the user is signed in or not
        // If they are we will put then to the tab bar viewcontroller
        // If not, we will put them in the login/signup viewcontroller
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                // User is logged in

                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController2 = storyBoard.instantiateViewController(withIdentifier: "HomeVC")
                viewController2.modalPresentationStyle = .fullScreen
                self.present(viewController2, animated: false, completion: nil)

            } else {
                // User is not logged In
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let viewController2 = storyBoard.instantiateViewController(withIdentifier: "signUpVC")
                viewController2.modalPresentationStyle = .fullScreen
                self.present(viewController2, animated: false, completion: nil)
            }
        }
    }
}
