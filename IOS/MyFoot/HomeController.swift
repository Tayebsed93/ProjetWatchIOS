//
//  HomeController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 13/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import WatchConnectivity


class HomeController: UIViewController, UITextFieldDelegate {
    

    var nationality = String()
    
    var passapikey = String()

    var isPlayer = Bool()
    
    @IBOutlet weak var btnFranceAlpha: UIButton!
    @IBOutlet weak var btnGermanyAlpha: UIButton!
    @IBOutlet weak var btnItalyAlpha: UIButton!
    
    @IBOutlet weak var validateFrance: UIImageView!
    @IBOutlet weak var validateGermany: UIImageView!
    @IBOutlet weak var validateItaly: UIImageView!
    
    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    public var playerUrlCompo = "/composition"
    
    @IBOutlet weak var anneeText: UITextField!
    let button = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPlayer = true
        
        // Add the view to the view hierarchy so that it shows up on screen

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)

        if WCSession.isSupported() {
            let session = WCSession.default
            session().delegate = self as! WCSessionDelegate
            session().activate()
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        callAPIResultat()
        
        //Apple Watch
        let session = WCSession.default
        guard session().isPaired && session().isWatchAppInstalled else {
            return
        }
        let ok = "yes"
        session().transferUserInfo(["backhome" : ok])
        
        //End
    }
    
    func France() {
        self.nationality = "France"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            viewController.passapikey = self.passapikey
            viewController.passapikeyCompo = self.passapikey
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func Allemagne() {
        self.nationality = "Germany"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            viewController.passapikey = self.passapikey
            viewController.passapikeyCompo = self.passapikey
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func Italy() {
        self.nationality = "Italy"
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            viewController.passapikey = self.passapikey
            viewController.passapikeyCompo = self.passapikey
            viewController.isPlayer = true
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    @IBAction func FranceClick(_ sender: Any) {
        let alert = UIAlertController(title: "Erreur", message: "Vous devez choisir l'équipe sur la montre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func AllemagneClick(_ sender: Any) {
        let alert = UIAlertController(title: "Erreur", message: "Vous devez choisir l'équipe sur la montre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ItalieClick(_ sender: Any) {
        let alert = UIAlertController(title: "Erreur", message: "Vous devez choisir l'équipe sur la montre", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func deconnecteButton(_ sender: Any) {
        //Apple Watch
        let session = WCSession.default
        guard session().isPaired && session().isWatchAppInstalled else {
            return
        }
        let ok = "yes"
        session().transferUserInfo(["deconexion" : ok])
        
        //End
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func callAPIResultat() {
        let apiKey = passapikey
        let urlToRequest = addressUrlString+playerUrlCompo
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                self.alerteMessage(message: (error?.localizedDescription)!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            //JSONSerialization in Object
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        if let resultatsCompos = json["composition"] as? [[String: Any]] {
                            for resultatCompo in resultatsCompos {
                                if case let nation as String = resultatCompo["nation"]{
                                    self.checkNation(nation: nation)
                                }
                            }
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                }
                
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alerteMessage(message : String) {
        
        var newMessage = ""
        if (message == "Could not connect to the server." ) {
            newMessage = "Impossible de se connecter au serveur."
            
            let alert = UIAlertController(title: "Erreur", message: newMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func checkNation(nation : String) {
        
        //Apple Watch
        let session = WCSession.default
        guard session().isPaired && session().isWatchAppInstalled else {
            return
        }
        
        session().transferUserInfo(["nation" : nation])
        
        //End
        
        if (nation == "France" ) {
            
            validateFrance.alpha = 1
            btnFranceAlpha.isEnabled = false
        }
        else if (nation == "Germany" ) {
            validateGermany.alpha = 1
            btnGermanyAlpha.isEnabled = false
        }
        
        else if (nation == "Italy" ) {
            validateItaly.alpha = 1
            btnItalyAlpha.isEnabled = false

        }
        
        
    }
    
}


extension HomeController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        
        DispatchQueue.main.async {
            if let name = userInfo["pays"] as? String {
                
                if name == "France" {
                    self.France()
                }
                else if name == "Germany" {
                    self.Allemagne()
                }
                else if name == "Italy" {
                    self.Italy()
                }
            }
        }
        
    }
}










