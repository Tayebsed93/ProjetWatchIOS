//
//  LoginController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 13/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import WatchConnectivity

class LoginController: UIViewController {
    
    @IBOutlet weak var lblConnexion: UILabel!
    
    @IBOutlet weak var lblAdresse: UILabel!
    
    @IBOutlet weak var lblMdp: UILabel!
    
    
    public var mutableURLRequest: NSMutableURLRequest!
    public var url: NSURL?
    public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
    var test = ""
    public var loginUrlString = "/login"
    var api:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
        //txtEMail.text = "az@gmail.com"
        //txtMdp.text = "az"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated)
        
        // Add the view to the view hierarchy so that it shows up on screen
        if WCSession.isSupported() {
            let session = WCSession.default
            session().delegate = self as! WCSessionDelegate
            session().activate()
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        print("click")
        callAPILogin()
    }
    
    func callAPILogin() {
        lblAdresse.text = "bonjour@gmail.com"
        lblMdp.text = "Lol"
        let urlToRequest = addressUrlString+loginUrlString
        let url4 = URL(string: urlToRequest)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url4)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = String(format:"email=%@&password=%@",lblAdresse.text!,lblMdp.text!)
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        
        
        let task = session4.dataTask(with: request as URLRequest)
        { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else
            {
                
                print("ERROR: \(error?.localizedDescription)")
                
                self.alerteMessage(message: (error?.localizedDescription)!)
                return
            }
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("Response : \n \(dataString)") //JSONSerialization in String
            
            
            //JSONSerialization in Object
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                DispatchQueue.main.async()
                    {
                        if let apiKey = json["apiKey"]
                        {
                            
                            self.passData(apiKey: apiKey as! String)
                            
                            //Apple Watch
                            let session = WCSession.default
                            guard session().isPaired && session().isWatchAppInstalled else {
                                return
                            }
                            session().transferUserInfo(["pagehome" : "pagehome"])
                            
                            //End
                        }
                        
                        if let messageError = json["message"]
                        {
                            self.alerteMessage(message: messageError as! String)
                        }
                        
                }
                /*
                 DispatchQueue.main.async() {
                 self.dismiss(animated: true, completion: nil)
                 }
                 */
                
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
        }
        ;task.resume()
    }
    
    func passData(apiKey : String) {
        print(apiKey)
        
        
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVc = storyboard.instantiateViewController(withIdentifier: "tbController") as! UITabBarController
        
        
        /////////****** 1er controller
        //Convertie la tabViewController en UINavigationController
        let navigation = tabVc.viewControllers?[0] as! UINavigationController
        
        //Convertie la UINavigationController en UIViewController (Home)
        let homeController = navigation.topViewController as? HomeController
        
        let scoreController = navigation.topViewController as? ScoreController
        
        //Envoie le nom et le mot de passe à la page statistique à home
        homeController?.passapikey = apiKey
        
        //Envoie le nom et le mot de passe à la page statistique à score
        scoreController?.passapikey = apiKey
        
        
        /////////****** 2nd controller
        //Chart
        /*
         let chartsViewController = tabVc.viewControllers![1] as! ChartsViewController
         //Envoie l'apikey à la page ChartsViewController
         chartsViewController.passapikey = apiKey
         
         //Change la page vers Statistique
         self.present(tabVc, animated: true, completion: nil)
         */
        /*
        //Remplissage
        let remplissageController = tabVc.viewControllers![1] as! RemplissageController
        
        //Envoie l'apikey à la page ChartsViewController
        remplissageController.passapikey = apiKey
        
 */
        //Change la page vers Statistique
        self.present(tabVc, animated: true, completion: nil)
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
    
    
    
    
}

extension LoginController: WCSessionDelegate {
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
        /*
        guard let name = userInfo["name"] as? String else {
            return
        }
 */
        DispatchQueue.main.async {
            if let name = userInfo["name"] as? String {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabVc = storyboard.instantiateViewController(withIdentifier: "inscriptionController") as! InscriptionController
                
                //Change la page vers Statistique
                self.present(tabVc, animated: true, completion: nil)
            }
        }

        
        if let name = userInfo["login"] as? [String] {
            let alert = UIAlertController(title: "Message", message: "Les données ont bien été saisie", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            //now we are adding the default action to our alertcontroller
            alert.addAction(defaultAction)
            self.present(alert, animated: true)
            lblAdresse.text = name[0]
            lblMdp.text = name[1]
        }

        
    }
    
    
}




