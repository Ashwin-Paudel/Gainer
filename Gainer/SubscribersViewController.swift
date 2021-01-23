//
//  SubscribersViewController.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-16.
//

import FirebaseAuth
import FirebaseFirestore
import SafariServices
import UIKit
import WebKit
// import GoogleMobileAds

struct variables {
    static var points = 300
}

class SubscribersViewController: UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet var webview: WKWebView!
    @IBOutlet var channelNameHeader: UILabel!
    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var subscribeButton: UIButton!
    @IBOutlet var skipChannelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    let db = Firestore.firestore()

    @IBOutlet var autoSubscribedSwitch: UISwitch!
    // Ads
//    var bannerView: GADBannerView!
//    var interstitial: GADInterstitial!

    var needToBe = 0
    var newSubscribers = ""
    var newsubscriberAsInt = 0

    let defaults = UserDefaults.standard

    @IBOutlet var pointsLabel: UILabel!

    var channelFinderURL = ""
    var contentsOfChannel = ""

    var channelSubsFinderURL = ""
    var contentsOfChannelSubsURL = ""

    var currentSubscribers = ""

    var ChannelIDD = ""
    var pointsPayouts = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewParent.isHidden = true

        reloadData()

        Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { _ in
            let alert = UIAlertController(title: "Daily Points", message: "You get 100 daily points", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { [self] _ in
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                    let userPoints = snapshot?.get("points") as! String
                    let payouts = "100"
                    let newPoints = Int(userPoints)! + Int(payouts)!
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["points": "\(newPoints)"])
                }

                alert.dismiss(animated: true, completion: nil)
            }
        }

//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["58587cebeebf08456dca302b7e95a202", "\(kGADSimulatorID)"]

//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

//           addBannerViewToView(bannerView)

//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//         bannerView.rootViewController = self
//
//        bannerView.load(GADRequest())
//
//        interstitial = createAndLoadInterstitial()
        let skipButtonTitle = NSLocalizedString("Skip", comment: "skipBTN")
        skipChannelButton.setTitle(skipButtonTitle, for: .normal)

        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { [self] snap, _ in
            let pointss = snap?.get("points") as? String
            self.pointsLabel.text = pointss
        }
        // Do any additional setup after loading the view.
    }

//    func createAndLoadInterstitial() -> GADInterstitial {
//      let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//      interstitial.delegate = self
//      interstitial.load(GADRequest())
//      return interstitial
//    }
//
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//      interstitial = createAndLoadInterstitial()
    @IBOutlet var webViewParent: UIView!
    //    }
    @IBAction func doneButtonParentAction(_ sender: Any) {
        webview.loadHTMLString("", baseURL: nil)
        webViewParent.isHidden = true
    }

    @IBAction func subscribeButtonAction(_ sender: Any) {
        if SettingsConfig.opensInMiniBrowser == true {
            confirmButton.isHidden = false
            webViewParent.isHidden = false
            webview.load(URLRequest(url: URL(string: "https://www.youtube.com/channel/\(ChannelIDD)")!))
        } else {
            UIApplication.shared.openURL(URL(string: "https://www.youtube.com/channel/\(ChannelIDD)")!)
        }
    }

    @IBAction func AutosubscribeSwitchButton(_ sender: Any) {
        if autoSubscribedSwitch.isOn == true {
            subscribeButtonAction(self)
            // Show the webview
            if webview.isLoading == true {
            } else {
                let strings = """
                        var btnelem=document.getElementsByClassName('style-scope ytd-subscribe-button-renderer')[0];
                        var subscribed = (btnelem.innerText.search("UNSUB")==-1)?false:true;
                    if(!subscribed){
                        document.getElementsByClassName('style-scope ytd-subscribe-button-renderer')[0].click();
                    };
                """
                webview.evaluateJavaScript(strings) { [self] _, err in
                    if let error = err?.localizedDescription {
                        print(error + " jijij")
                    }
                }

                webview.reload()
                if webview.isLoading == true {
                } else {
                    doneButtonParentAction(self)
                    confirmButtonAction(self)
                    AutosubscribeSwitchButton(self)
                }
            }

        } else if autoSubscribedSwitch.isOn == false {}
    }

    // func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//          [NSLayoutConstraint(item: bannerView,
//                              attribute: .bottom,
//                              relatedBy: .equal,
//                              toItem: bottomLayoutGuide,
//                              attribute: .top,
//                              multiplier: 1,
//                              constant: 0),
//           NSLayoutConstraint(item: bannerView,
//                              attribute: .centerX,
//                              relatedBy: .equal,
//                              toItem: view,
//                              attribute: .centerX,
//                              multiplier: 1,
//                              constant: 0)
//          ])
//       }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        confirmButtonAction(self)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButtonAction(_ sender: Any) {
        if let url = URL(string: channelSubsFinderURL) {
            do {
                let contents = try String(contentsOf: url)
                contentsOfChannelSubsURL = contents
            } catch {
                // contents could not be loaded
            }
        } else {}
        let needToBe = Int(currentSubscribers)
        let welcome = try? JSONDecoder().decode(GACount.self, from: contentsOfChannelSubsURL.data(using: .utf8)!)
        let newSubscribers = welcome?.items[0].statistics.subscriberCount
        let newsubscriberAsInt = Int(newSubscribers!)
        if currentSubscribers.count > 3 {
            db.collection("Channels").document(ChannelIDD).getDocument { [self] snapshot, _ in
                let gotAmount = snapshot?.get("got") as! String
                let idAmount = snapshot?.get("id") as! String
                db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["subscribedTo": FieldValue.arrayUnion([idAmount])])
                let wantAmount = snapshot?.get("want") as! String
                let newPoints = Int(gotAmount)! + 1
                db.collection("Channels").document(ChannelIDD).updateData(["got": "\(newPoints)"])
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                    let userPoints = snapshot?.get("points") as! String
                    let payouts = pointsPayouts
                    let newPoints = Int(userPoints)! + Int(payouts)!
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["points": "\(newPoints)"])
                    let userPointsNew = snapshot?.get("points") as! String
                    self.pointsLabel.text = userPointsNew
                    confirmButton.isHidden = true
                    if gotAmount < wantAmount {
                    } else {
                        db.collection("Channels").document(ChannelIDD).delete { [self] _ in

                            db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                                "ownedChannels": FieldValue.arrayRemove([idAmount])
                            ])

//                            db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["ownedChannels": FieldValue.arrayRemove([ChannelIDD])])
                        }
                    }
                    reloadData()
                }
            }
        } else {
            if needToBe! < newsubscriberAsInt! {
                //            print("DidSubscribe")
                //
                //            confirmButton.isHidden = true
                //
                //            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] (snapshot, error) in
                //                       let points = snapshot?.get("points") as? String
                //                let amountIntPoints = Int(points!)
                //
                //
                //
                //
                //                db.collection("users").document(Auth.auth().currentUser!.uid).setData(["points": "6"])
                //                self.pointsLabel.text = points
                //                   }
                //
                //
                //
                //
                //
                //            notToSubscribeTo.append(ChannelIDD)
                //            reloadData()
                db.collection("Channels").document(ChannelIDD).getDocument { [self] snapshot, _ in
                    let gotAmount = snapshot?.get("got") as! String
                    let idAmount = snapshot?.get("id") as! String

                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["subscribedTo": FieldValue.arrayUnion([idAmount])])

                    let wantAmount = snapshot?.get("want") as! String
                    let newPoints = Int(gotAmount)! + 1
                    db.collection("Channels").document(ChannelIDD).updateData(["got": "\(newPoints)"])

                    if gotAmount < wantAmount {
                    } else {
                        db.collection("Channels").document(ChannelIDD).delete { [self] _ in
                            db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                                "ownedChannels": FieldValue.arrayRemove([idAmount])
                            ])
                        }
                    }
                }
                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                    let userPoints = snapshot?.get("points") as! String
                    let payouts = pointsPayouts
                    let newPoints = Int(userPoints)! + Int(payouts)!
                    db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["points": "\(newPoints)"])
                    let userPointsNew = snapshot?.get("points") as! String
                    self.pointsLabel.text = userPointsNew

                    let alert = UIAlertController(title: "Yay", message: "You get 20 points for subscribing to this channel", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                    }
                    alert.addAction(okAction)
                    self.confirmButton.isHidden = true
                    self.present(alert, animated: true, completion: nil)
                    reloadData()
                }

            } else if needToBe! == newsubscriberAsInt! {
                let alert = UIAlertController(title: "You did not subscribe", message: "Try subscribing again or skip the channel", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                }
                alert.addAction(okAction)
                confirmButton.isHidden = true
                present(alert, animated: true, completion: nil)
            } else if needToBe! > newsubscriberAsInt! {
                let alert = UIAlertController(title: "You did not subscribe", message: "Try subscribing again or skip the channel", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                }
                alert.addAction(okAction)
                confirmButton.isHidden = true
                present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func skipChannelButton(_ sender: Any) {
        reloadData()
    }

    func reloadData() {
        confirmButton.isHidden = true
        db.collection("Channels").getDocuments { [self] querySnapshot, err in
            if let err = err {
            } else {
                let randDocument = querySnapshot?.documents.randomElement()!.data()
                var subbedToIDs = [String]()
                let channelID = randDocument!["id"] as! String

                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                    subbedToIDs = snapshot!["subscribedTo"] as! [String]
                    for name in subbedToIDs {
                        channelNameHeader.text = "Loading..."
                        if name == channelID {
                            reloadData()
                            print("Found \(name) yiyiyids")
                            channelNameHeader.text = "If channels keep on switching, No more are channels left"
                            break
                        }
                    }
                }
                let payoutForPoints = randDocument!["payout"] as! String
                ChannelIDD = channelID
                pointsPayouts = payoutForPoints
                channelSubsFinderURL = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=\(channelID)&key=AIzaSyABxCY60iYu6YyMdMlBHRwRiuTVI_ZRc3M"

                channelFinderURL = "https://www.googleapis.com/youtube/v3/channels?id=\(channelID)&part=snippet&key=AIzaSyABxCY60iYu6YyMdMlBHRwRiuTVI_ZRc3M"
                if let url = URL(string: channelFinderURL) {
                    do {
                        let contents = try String(contentsOf: url)
                        contentsOfChannel = contents
                    } catch {
                        // contents could not be loaded
                    }
                } else {
                    // the URL was bad!
                }
                if let url = URL(string: channelSubsFinderURL) {
                    do {
                        let contents = try String(contentsOf: url)
                        contentsOfChannelSubsURL = contents
                    } catch {
                        // contents could not be loaded
                    }
                } else {
                    // the URL was bad!
                }
                do {
                    let welcome = try! JSONDecoder().decode(CHTRootClass.self, from: contentsOfChannel.data(using: .utf8)!)
                    channelNameHeader.text = "Subscribe to \(welcome.items[0].snippet.title!)"

//                                UIView.transition(with: channelNameHeader,
//                                              duration: 0.25,
//                                               options: .transitionCrossDissolve,
//                                            animations: { [weak self] in
//                                                self?.channelNameHeader.text = (arc4random() % 2 == 0) ? "Loading" : "Subscribe to \(welcome.items[0].snippet.title!)"
//                                         }, completion: nil)

//                                channelNameHeader.text = "Subscribe to \(welcome.items[0].snippet.title!)"
                    let channelImageURL = welcome.items[0].snippet.thumbnails.high.url
                    channelImageView.loadImageWithUrl(URL(string: channelImageURL!)!)
                    let payout1 = randDocument!["payout"] as! String
                    let payout = Int(payout1)

                    let buttonTitle = NSLocalizedString("Subscribe", comment: "subscribeBTN")
                    self.subscribeButton.setTitle(buttonTitle, for: .normal)

                    //                    self.subscribeButton.setTitle("Subscribe For \(payout!) Points", for:  .normal)
                    // If were doing payouts
                    db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { [self] snapshot, _ in
                        pointsLabel.text = snapshot?.get("points") as? String
                    }
                    db.collection("Channels").getDocuments { [self] _, err in
                        if let err = err {
                        } else {
                            //                            self.confirmButton.isHidden = false
                            let decoder = JSONDecoder()
                            let welcome = try? decoder.decode(GACount.self, from: contentsOfChannelSubsURL.data(using: .utf8)!)
                            currentSubscribers = (welcome?.items[0].statistics.subscriberCount)!
                        }
                    }

                } catch {}
            }
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

// MARK: - CHTRootClass

public struct CHTRootClass: Decodable {
    public var etag: String!
    public var items: [CHTItem]!
    public var kind: String!
    public var pageInfo: CHTPageInfo!
}

// MARK: - CHTDefault

public struct CHTDefault: Decodable {
    public var height: Int!
    public var url: String!
    public var width: Int!
}

// MARK: - CHTHigh

public struct CHTHigh: Decodable {
    public var height: Int!
    public var url: String!
    public var width: Int!
}

// MARK: - CHTItem

public struct CHTItem: Decodable {
    public var etag: String!
    public var id: String!
    public var kind: String!
    public var snippet: CHTSnippet!
}

public struct CHTLocalized: Decodable {
    public var descriptionField: String!
    public var title: String!
}

public struct CHTMedium: Decodable {
    public var height: Int!
    public var url: String!
    public var width: Int!
}

// MARK: - CHTPageInfo

public struct CHTPageInfo: Decodable {
    public var resultsPerPage: Int!
    public var totalResults: Int!
}

// MARK: - CHTSnippet

public struct CHTSnippet: Decodable {
    public var country: String!
    public var customUrl: String!
    public var descriptionField: String!
    public var localized: CHTLocalized!
    public var publishedAt: String!
    public var thumbnails: CHTThumbnail!
    public var title: String!
}

// MARK: - CHTThumbnail

public struct CHTThumbnail: Decodable {
    public var defaultField: CHTDefault!
    public var high: CHTHigh!
    public var medium: CHTMedium!
}

// MARK: - GACount

struct GACount: Codable {
    let kind, etag: String
    let pageInfo: GAPageInfo
    let items: [GAItem]
}

// MARK: - Item

struct GAItem: Codable {
    let kind, etag, id: String
    let statistics: GAStatistics
}

// MARK: - Statistics

struct GAStatistics: Codable {
    let viewCount, subscriberCount: String
    let hiddenSubscriberCount: Bool
    let videoCount: String
}

// MARK: - PageInfo

struct GAPageInfo: Codable {
    let totalResults, resultsPerPage: Int
}

extension UIImageView {
    func loadImageWithUrl(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension WKWebView {
    func runJavaScriptInMainFrame(scriptString: NSString) {}
}
extension String {
func localized(lang:String) ->String {

    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}}
