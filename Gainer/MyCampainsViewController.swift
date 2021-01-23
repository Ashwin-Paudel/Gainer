//
//  MyCampainsViewController.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-16.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit
// import GoogleMobileAds

class MyCampainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var pointsLabel: UILabel!
    let db = Firestore.firestore()

    var channelContentsJSON = ""
    
//    var bannerView: GADBannerView!

    var ownedChannelID = ["hi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false) { [self] timer in
//            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] (snapshot, error) in
//                let channelss = snapshot?.get("ownedChannels") as? [String]
//                itemCount = channelss!
//            }
//        }
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
            let channelss = snap?.get("ownedChannels") as? [String]
            itemCount = channelss!
        }
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] _, _ in
            tableview.reloadData()
        }
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//
//           addBannerViewToView(bannerView)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["58587cebeebf08456dca302b7e95a202", "\(kGADSimulatorID)"]
//
//
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//         bannerView.rootViewController = self
//
//        bannerView.load(GADRequest())
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] _ in
            tableview.reloadData()
        }
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
            let pointss = snap?.get("points") as? String
            self.pointsLabel.text = pointss
        }
        
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.showsVerticalScrollIndicator = false
        
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
            let pointss = snap?.get("ownedChannels") as! [String]
            ownedChannelID = pointss
        }
    }
    
    var itemCount = [String]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
            let channelss = snapshot?.get("ownedChannels") as? [String]
            itemCount = channelss!
        }
        return itemCount.count
    }

//    func addBannerViewToView(_ bannerView: GADBannerView) {
//            bannerView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(bannerView)
//            view.addConstraints(
//              [NSLayoutConstraint(item: bannerView,
//                                  attribute: .bottom,
//                                  relatedBy: .equal,
//                                  toItem: bottomLayoutGuide,
//                                  attribute: .top,
//                                  multiplier: 1,
//                                  constant: 0),
//               NSLayoutConstraint(item: bannerView,
//                                  attribute: .centerX,
//                                  relatedBy: .equal,
//                                  toItem: view,
//                                  attribute: .centerX,
//                                  multiplier: 1,
//                                  constant: 0)
//              ])
//           }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, complete in
            let alertController = UIAlertController(title: "Are you sure?", message: "You will not get your points back \n You cannot reverse this action", preferredStyle: .alert)
                    
            let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (_: UIAlertAction) in
                complete(false)
                alertController.dismiss(animated: true, completion: nil)
            }
                    
            let action2 = UIAlertAction(title: "Delete", style: .destructive) { (_: UIAlertAction) in
                db.collection("Channels").document(ownedChannelID[indexPath.row]).delete { [self] _ in
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["ownedChannels": FieldValue.arrayRemove([ownedChannelID[indexPath.row]])])
                    db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
                        let pointss = snap?.get("ownedChannels") as! [String]
                        ownedChannelID = pointss
                    }
                    Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [self] _ in
                        tableview.reloadData()
                    }
                    complete(true)
                }
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            present(alertController, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "campainCell") as! CampainsTableViewCell
        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
            let channelss = snapshot?.get("ownedChannels") as? [String]

            if channelss?.isEmpty == true, tableview.visibleCells.isEmpty == true {
            } else {
                let gradientImage = UIImage.gradientImage(with: cell.progressBar.frame,
                                                          colors: [UIColor.red.cgColor, UIColor.orange.cgColor],
                                                          locations: nil)
                cell.progressBar.progressImage = gradientImage!
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                    let channelss = snapshot?.get("ownedChannels") as? [String]
                    let channelContentsURL = "https://www.googleapis.com/youtube/v3/channels?id=\(channelss![indexPath.item])&part=snippet&key=AIzaSyABxCY60iYu6YyMdMlBHRwRiuTVI_ZRc3M"
            
                    if let url = URL(string: channelContentsURL) {
                        do {
                            let contents = try String(contentsOf: url)
                            channelContentsJSON = contents
                        } catch {}
                    } else {}
                    let welcome = try! JSONDecoder().decode(CHTRootClass.self, from: channelContentsJSON.data(using: .utf8)!)
                    cell.channelName.text = welcome.items[0].snippet.title
                    cell.channelImage.loadImageWithUrl(URL(string: welcome.items[0].snippet.thumbnails.high.url)!)
                    let channelIDD = channelss![indexPath.row]
            
                    db.collection("Channels").document(channelIDD).getDocument { docSnapshot, _ in
                        let gotAmount = docSnapshot?.get("got") as! String
                        let wantAmount = docSnapshot?.get("want") as! String
                        let wantInttt = Double(wantAmount)
                        let gotInttt = Double(gotAmount)
                        let perccent = gotInttt!/wantInttt!
                        let finalPercent = perccent*100
                        if SettingsConfig.showsPercentage == true {
                            cell.progressLabel.text = "\(Int(finalPercent))%"
                        } else {
                            cell.progressLabel.text = gotAmount + "/" + wantAmount
                        }
                
                        cell.progressBar.setProgress(Float(Double(gotAmount)! / Double(wantAmount)!), animated: true)
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
    @IBAction func refreshButton(_ sender: Any) {
        tableview.reloadData()
    }
}

private extension UIImage {
    static func gradientImage(with bounds: CGRect,
                              colors: [CGColor],
                              locations: [NSNumber]?) -> UIImage?
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
