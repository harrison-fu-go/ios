//
//  ViewController.swift
//  YYGoogleSignIn
//
//  Created by HarrisonFu on 2024/8/9.
//

import UIKit
import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleService.shared.setupInit()
        // Do any additional setup after loading the view.
    }

    @IBAction func startGoogleLogin(_ sender: Any) {
        
//        GoogleService.shared.signIn(withViewController: self) { [weak self] (gUser) in
//            guard let self = self else { return }
//            var third_token = gUser.authentication.accessToken
//        }
//        GoogleService.shared.signIn(withViewController: self) { [weak self] (gUser) in
//            guard let self = self else { return }
//            var third_token = gUser.authentication.accessToken
//            print("============= \(third_token)")
//        }
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("=============idToken error: \(error)")
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("=============idToken is null")
                return
            }
            print("=============idToken: \(idToken)")
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
        }
    }
    
    
}


public class GoogleService: NSObject {
    
    public typealias SignInHandle = (GIDGoogleUser)->Void
    
    public static let shared = GoogleService()
    
    private var signHandle: SignInHandle?
    
    public func setupInit() {
        
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.error)
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
//        Crashlytics.crashlytics()
        
    }
    
}



    
