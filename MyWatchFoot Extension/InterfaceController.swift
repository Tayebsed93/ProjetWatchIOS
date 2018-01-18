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


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self as! WCSessionDelegate
            session.activate()
        }
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
    @IBAction func ConnecterButton() {
        self.pushController(withName: "InscripController", context: nil)
    }
    
    @IBAction func InscriptionButton() {
        let session = WCSession.default
        var name = "Inscrire"
        session.transferUserInfo(["name" : name])
    }
}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        //
        
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //
    }
    
}
