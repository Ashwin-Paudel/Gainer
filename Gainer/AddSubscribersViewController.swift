//
//  AddSubscribersViewController.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-15.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
import WebKit

class AddSubscribersViewController: UIViewController {
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var addChannelTextField: UITextField!
    @IBOutlet var wantTextField: UITextField!
    @IBOutlet var webview: WKWebView!
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.isHidden = true
        confirmBtn.isHidden = true
        
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
            let pointss = snap?.get("points") as? String
            self.pointsLabel.text = pointss
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backNavButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addButton(_ sender: Any) {
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
            let userPoints = snapshot?.get("points") as! String
            let WantasIntt = Int(wantTextField.text!)
            
            let lost = WantasIntt!*20
            if Int(userPoints)! < lost {
                let alert = UIAlertController(title: "Not enough Points", message: "Subscribe to more channels for points \n You can only have \(Int(userPoints)! / 20) Subscribers", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.webview.isHidden = false
                self.webview.load(URLRequest(url: URL(string: "https://www.youtube.com/channel/\(addChannelTextField.text!)")!))
                self.confirmBtn.isHidden = false
                let PayoutasInt = 20
                let WantasInt = Int(wantTextField.text!)
                let total = PayoutasInt*WantasInt!
                self.confirmBtn.setTitle("Confirm \n Total Cost: \(total)", for: .normal)
        
                self.wantTextField.isEnabled = false
                self.addChannelTextField.isEnabled = false
        
                self.cancelBtn.isHidden = false
            }
        }
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        if addChannelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            wantTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
        } else {
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                let userPoints = snapshot?.get("points") as! String
                let WantasIntt = Int(wantTextField.text!)
                
                let lost = WantasIntt!*20
                if Int(userPoints)! < lost {
                } else {
                    let newPoint = Int(userPoints)! - lost
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["points": "\(newPoint)"])
            
                    db.collection("Channels").document(addChannelTextField.text!).setData([
                        "id": "\(addChannelTextField.text!)",
                        "want": wantTextField.text!,
                        "got": "0",
                        "payout": "15"
                    ]) { err in
                        if let err = err {
                        } else {}
                    }
                    // Remove points
     
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["ownedChannels": FieldValue.arrayUnion([addChannelTextField.text])])
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["subscribedTo": FieldValue.arrayUnion([addChannelTextField.text])])
                }
                self.dismiss(animated: true, completion: nil)
            }
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
