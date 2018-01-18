//
//  LoadCompositionController.swift
//  MyWatchFoot Extension
//
//  Created by Tayeb Sedraia on 16/12/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity


class LoadCompositionController: WKInterfaceController {
    
    
    
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
}


extension LoadCompositionController: WCSessionDelegate {
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        if let name = userInfo["playerforwatch"]  {
            /*
             var ctx: [String: Any] = [:]
             ctx["player"] = name
             */
            self.pushController(withName: "PlayersController", context: name)
           
        }
        
        if let name = userInfo["backhome"]  {

            self.pushController(withName: "CountryController", context: nil)
            
        }
        
        //Button deconnexion retour vers la page de connexion sur la watch
        if let deconexion = userInfo["deconexion"] as? String {
            self.pushController(withName: "InscripController", context: nil)
        }
        
        
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //
    }
    
}

