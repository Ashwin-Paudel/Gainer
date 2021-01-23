//
//  LoginViewController.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-15.
// Sub4z

import Firebase
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let emailTextFIeldstring = UserDefaults.standard.string(forKey: "loginEmailTextField")
        emailTextField.text = emailTextFIeldstring
                
        let passwordTextFieldString = UserDefaults.standard.string(forKey: "loginPasswordTextField")
        passwordTextField.text = passwordTextFieldString
        setUpElements()
    }
    
    func setUpElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
        view.applyGradienta(colors: [Utilities.UIColorFromRGB(0x00bbaa).cgColor, Utilities.UIColorFromRGB(0x003833).cgColor])
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // TODO: Validate Text Fields
        UserDefaults.standard.set(emailTextField.text, forKey: "loginEmailTextField")
        UserDefaults.standard.set(passwordTextField.text, forKey: "loginPasswordTextField")
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

/*
 Multiple commands produce '/Users/Ashwin/Library/Developer/Xcode/DerivedData/Gainer-esexuyczghaaczazbueptvgouuig/Build/Products/Debug-iphonesimulator/Gainer.app/Info.plist':
 1) Target 'Gainer' (project 'Gainer') has copy command from '/Users/Ashwin/Downloads/Gainer/Gainer/Info.plist' to '/Users/Ashwin/Library/Developer/Xcode/DerivedData/Gainer-esexuyczghaaczazbueptvgouuig/Build/Products/Debug-iphonesimulator/Gainer.app/Info.plist'
 2) Target 'Gainer' (project 'Gainer') has process command with output '/Users/Ashwin/Library/Developer/Xcode/DerivedData/Gainer-esexuyczghaaczazbueptvgouuig/Build/Products/Debug-iphonesimulator/Gainer.app/Info.plist'

 */
