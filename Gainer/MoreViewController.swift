//
//  MoreViewController.swift
//  Gainer
//
//  Created by आश्विन पौडेल  on 2021-01-19.
//

// import GoogleMobileAds
import FirebaseAuth
import FirebaseFirestore
import UIKit

class MoreViewController: UIViewController {
//    var interstitial: GADInterstitial!
//    var bannerView: GADBannerView!

    @IBOutlet var helloNameLabel: UILabel!

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
            let name = snapshot?.get("firstname") as! String

            helloNameLabel.text = "Hello, \(name)"
        }

//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let request = GADRequest()
//        interstitial.load(request)
//
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//           addBannerViewToView(bannerView)
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//         bannerView.rootViewController = self
//        bannerView.load(GADRequest())
    }

//
//    @IBAction func showInterstitial(_ sender: Any) {
    // if (interstitial.isReady) {
//            interstitial.present(fromRootViewController: self)
//            interstitial = createAd()
//        }
//    }
//
//    func createAd() -> GADInterstitial {
    // let inter = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    // inter.load(GADRequest())
//        return inter
//    }
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
    @IBAction func logoutBTN(_ sender: Any) {
        logout()
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewController2 = storyBoard.instantiateViewController(withIdentifier: "signUpVC")
            viewController2.modalPresentationStyle = .fullScreen
            present(viewController2, animated: false, completion: nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
