//
//  PlayersController.swift
//  MyWatchFoot Extension
//
//  Created by Tayeb Sedraia on 04/12/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity


class PlayersController: WKInterfaceController {
    
    var yourArray = [String]()
    
    var currentiPhoneTag = 0
    
    @IBOutlet var playerTable: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self as! WCSessionDelegate
            session.activate()
        }
        
    
        let player = context
        if let swiftArray = context as! NSArray as? [String] {
            yourArray.append(contentsOf: swiftArray)
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        self.playerTable.setNumberOfRows(yourArray.count, withRowType: "mySuperRow")
        
        for i in 0..<yourArray.count {
            if let row = playerTable.rowController(at: i) as? PlayerRowController {
                row.playerLabel.setText(yourArray[i])
            }
 
    }
        

}
    
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        print(yourArray[rowIndex])
        let session = WCSession.default
        session.transferUserInfo(["itemplayer" : yourArray[rowIndex]])
        session.transferUserInfo(["tagplayer" : self.currentiPhoneTag])
        let action1 = WKAlertAction.init(title: "Annuler", style:.cancel) {
            print("cancel action")
        }
        
        let action2 = WKAlertAction.init(title: "Accepter", style:.default) {
            print("default action")
            session.transferUserInfo(["accepter" : self.yourArray[rowIndex]])
            self.pushController(withName: "LoadCompositionController", context: self.yourArray[rowIndex])
        }
        
        let action3 = WKAlertAction.init(title: "Refuser", style:.destructive) {
            print("destructive action")
        }
        
        presentAlert(withTitle: "Choisir", message: yourArray[rowIndex], preferredStyle:.actionSheet, actions: [action1,action2,action3])
    }
}

extension PlayersController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let curentTag = userInfo["curentTag"] as? Int {
                
                self.currentiPhoneTag = curentTag
                print("PlayerController ", curentTag)
            }
            
            if let name = userInfo["backhome"]  {
                
                self.pushController(withName: "CountryController", context: nil)
                
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

