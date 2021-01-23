//
//  ForgotPasswordViewController.swift
//  Gainer
//
//  Created by आश्विन पौडेल  on 2021-01-19.
//

import FirebaseAuth
import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var sendEmailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        Utilities.styleFilledButton(sendEmailButton)
        view.applyGradienta(colors: [Utilities.UIColorFromRGB(0x00bbaa).cgColor, Utilities.UIColorFromRGB(0x003833).cgColor])

        // Do any additional setup after loading the view.
    }

    @IBAction func emailSendTapped(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { [self] error in
            if let error = error {
                errorLabel.alpha = 1
                errorLabel.text = error.localizedDescription
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
