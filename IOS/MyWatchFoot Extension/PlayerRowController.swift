//
//  PlayerRowController.swift
//  MyWatchFoot Extension
//
//  Created by Tayeb Sedraia on 08/12/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import WatchKit

class PlayerRowController: NSObject {
    
    @IBOutlet var playerLabel: WKInterfaceLabel!
    
    
    
    public func setNumber(_ number:Int) {
        self.playerLabel.setText(String(number))
    }
    
    var text: String = "" {
        willSet {
            self.playerLabel.setText(newValue)
        }
    }
    

    
}

