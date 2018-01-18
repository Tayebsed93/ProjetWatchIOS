//
//  PlayerController.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 23/09/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import UIKit
import AVFoundation
import WatchConnectivity

class PlayerController: UITableViewController, UISearchBarDelegate {
    
    var players: [Player]?
    var player: Player?

    var nb: Int = 0
    var nationality = String()
    var name = String()
    
    var curentName = String()
    var curentTag = Int()
    var passapikey = String()
    
    @IBOutlet weak var searchBar: UISearchBar!
    public var addressUrlString = "http://localhost:8888/FootAPI/Pictures"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Add the view to the view hierarchy so that it shows up on screen
        if WCSession.isSupported() {
            let session = WCSession.default
            session().delegate = self as! WCSessionDelegate
            session().activate()
        }
        
        print("Player ", passapikey)
        //Recuperer Donnée de la BDD
        //loadData()
        

        searchBar.text = ""

        
        self.title = nationality
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        self.loadSearchData(_cleRecherche: keywords!)
        

        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if (players?.count != nil) {
            return (players?.count)!
        }
        else {
            return 0
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
    
         var mainImageView = cell?.viewWithTag(1) as! UIImageView
            if let profileImageName = UIImage(named: (players?[indexPath.row].name)!) {
                mainImageView.image = UIImage(named: (players?[indexPath.row].name)!)
            }
            else{
                mainImageView.image = UIImage(named: "profile")
            }
        
        // Nom du joueur
        let name:String
        let labelName = cell?.viewWithTag(2) as! UILabel
        labelName.text = players?[indexPath.row].name
        
        // Age
        let labelAge = cell?.viewWithTag(3) as! UILabel
        let a = Int((players?[indexPath.row].age)!)
        let b: String = String(a)
        labelAge.text = b + " Ans"
        
        var paysImage = cell?.viewWithTag(4) as! UIImageView
        paysImage.image = UIImage(named: nationality)
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.viewWithTag(2) as! UILabel
        
        self.curentName = currentItem.text!
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Supprimer") { (action, indexPath) in
            print("Suprime", indexPath)
            self.tableView.reloadData()
            
        }
        
        //self.tableView.reloadData()
        return [delete]
    }
    
    
    
    @IBAction func DeconnexionClick(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
            viewController.nationality = self.nationality
            viewController.isPlayer = false
            viewController.curentName = self.curentName
            viewController.curentTag = self.curentTag
            viewController.passapikey = self.passapikey
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: false)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension PlayerController: WCSessionDelegate {
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
            
             if let itemplayer = userInfo["itemplayer"] as? String  {
                self.loadSearchData(_cleRecherche: itemplayer)
                self.tableView.reloadData()
                /*
                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
                    viewController.nationality = self.nationality
                    viewController.isPlayer = false
                    viewController.curentName = itemplayer
                    viewController.curentTag = self.curentTag
                    if let navigator = self.navigationController {
                        navigator.pushViewController(viewController, animated: false)
                    }
                }
                */
             }
            
            
            if let itemplayer = userInfo["accepter"] as? String  {
                
                 if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CompositionController") as? CompositionController {
                 viewController.nationality = self.nationality
                 viewController.isPlayer = false
                 viewController.curentName = itemplayer
                 viewController.curentTag = self.curentTag
                 viewController.passapikey = self.passapikey
                 if let navigator = self.navigationController {
                 navigator.pushViewController(viewController, animated: false)
                 }
                 }
                 
            }
            
            
            
            
        }
        
    }
    
    
}


