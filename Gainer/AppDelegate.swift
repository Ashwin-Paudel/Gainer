//
//  AppDelegate.swift
//  Gainer
//
//  Created by Ashok Paudel on 2021-01-15.
//

import Firebase
import FirebaseFirestore
import UIKit
// import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    let gcmMessageIDKey = "gcm.Message_ID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["58587cebeebf08456dca302b7e95a202", "\(kGADSimulatorID)"]

        return true
    }
}
