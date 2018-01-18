//
//  CountryController.swift
//  MyWatchFoot Extension
//
//  Created by Tayeb Sedraia on 03/12/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreData

class CountryController: WKInterfaceController {
    
    @IBOutlet var btnFranceAlpha: WKInterfaceButton!
    
    @IBOutlet var btnGermanyAlpha: WKInterfaceButton!
    
    @IBOutlet var btnItalyAlpha: WKInterfaceButton!
    
    var country : String = ""
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
    
    
    @IBAction func BtnFrance() {
        
        let session = WCSession.default
        country = "France"
        session.transferUserInfo(["pays" : country])
        self.pushController(withName: "LoadCompositionController", context: nil)
 

    }
    
    @IBAction func BtnGermany() {
        country = "Germany"
        let session = WCSession.default
        session.transferUserInfo(["pays" : country])
        self.pushController(withName: "LoadCompositionController", context: nil)
    }
    
    @IBAction func BtnItaly() {
        country = "Italy"
        let session = WCSession.default
        session.transferUserInfo(["pays" : country])
        self.pushController(withName: "LoadCompositionController", context: nil)
    }

}

extension CountryController: WCSessionDelegate {
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let nation = userInfo["nation"] as? String {
                if nation == "France" {
                    self.btnFranceAlpha.setEnabled(false)
                }
                else if nation == "Germany" {
                    self.btnGermanyAlpha.setEnabled(false)
                }
                else if nation == "Italy" {
                    self.btnItalyAlpha.setEnabled(false)
                }
            }
            
            //Button deconnexion retour vers la page de connexion sur la watch
            if let deconexion = userInfo["deconexion"] as? String {
                self.pushController(withName: "InscripController", context: nil)
            }
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //
    }
    
}
