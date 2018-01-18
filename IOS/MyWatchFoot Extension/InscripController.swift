//
//  InterfaceController.swift
//  MyWatchFoot Extension
//
//  Created by Tayeb Sedraia on 24/11/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InscripController: WKInterfaceController {
    
    @IBOutlet var lblLog: WKInterfaceLabel!
    
    var languages = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self as! WCSessionDelegate
            session.activate()
        }
        self.lblLog.setAlpha(0)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func LoginButton() {
        self.presentTextInputController(withSuggestions: ["Login"], allowedInputMode: .plain) { (result) in
            guard let text = result as? [String] else {
                return
            }
            print(text[0])
            if self.languages.count != 0 {
                self.languages.remove(at: 0)
            }
            
            self.languages.insert(text[0], at: 0)
            let string = self.languages.joined(separator: " ")
            self.lblLog.setAlpha(1)
            self.lblLog.setText(string)
        }
    }
    
    @IBAction func PasswordButton() {
        self.presentTextInputController(withSuggestions: ["Mdp"], allowedInputMode: .plain) { (result) in
            guard let text = result as? [String] else {
                return
            }
            print(text[0])
            if self.languages.count == 2 {
                self.languages.remove(at: 1)
            }
            else if self.languages.count == 1 {
                self.languages.insert(text[0], at: 1)
            }
            
            let string = self.languages.joined(separator: " ")
            
            self.lblLog.setAlpha(1)
            self.lblLog.setText(string)
        }
    }
    @IBAction func OKButton() {
        let session = WCSession.default
        session.transferUserInfo(["login" : languages])
    }
}

extension InscripController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        guard let name = userInfo["pagehome"] as? String else {
            return
        }
        self.pushController(withName: "CountryController", context: nil)
        
        
    }
    
}

