//
//  ViewController.swift
//  FireBaseDB
//
//  Created by Vera on 17/12/1939 Saka.
//  Copyright © 1939 Vera. All rights reserved.
//

import UIKit

import FirebaseDatabase
class ArtistModel {
    
    var id: String?
    var name: String?
    var genre: String?
    
    init(id: String?, name: String?, genre: String?){
        self.id = id
        self.name = name
        self.genre = genre
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var firebaseTableView: UITableView!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var artistList = [ArtistModel]()
    
    @IBOutlet weak var updateDatabaseLabel: UILabel!
    var rootPath:DatabaseReference?
    var handler:DatabaseHandle?
      var refArtists: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
       firebaseTableView.layer.borderWidth = 1.0
       firebaseTableView.layer.cornerRadius = 10
       firebaseTableView.layer.borderColor = UIColor.clear.cgColor
        refArtists = Database.database().reference().child("artists");
        // Mark: connect firbase using path
        let ref = Database.database().reference(withPath: "family")
//         ref = Database.database().reference(withPath: "family")
//         let members = ref?.child("veerareddy")
//         print((members?.key)!)
        
        refArtists.observe(.value) { (snapshot) in
            if snapshot.childrenCount > 0{
                self.artistList.removeAll()
                for artists in snapshot.children.allObjects as! [DataSnapshot]{
                    //let artistObject = artists.value as? [String: AnyObject]
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    let artistName  = artistObject?["artistName"]
                    let artistId  = artistObject?["id"]
                    let artistGenre = artistObject?["artistGenre"]
                    let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
                    self.artistList.append(artist)
                }
                //reloading the tableview
                self.firebaseTableView.reloadData()
                
            }
        }
        
        
        ref.observe(.value, with: { snapshot in
            print(snapshot.value ?? "defalut")
            for member in snapshot.children{
               let snap = member as! DataSnapshot
                if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
                    print(snapshotValue["veerareddy"]!)
                    print((snapshotValue["amalareddy"]!))
                    let child = snapshotValue["amalareddy"]!
                    print((child as! NSDictionary)["age"]!)
                    print(snapVal)
                }
            }
        })
//        handler = Database.database().reference().child("family").observe(.childAdded, with: { (snapshot) in
//            print(snapshot.value ?? "Defalut")
//        })
        
        
        
       //let rootRef = FIRDatabase.database().reference()
       
       // let ref2 = Database.database().reference()
        /* let rootRef = FIRDatabase.database().reference()
         
         // 2
         let childRef = FIRDatabase.database().reference(withPath: "grocery-items")
         
         // 3
         let itemsRef = rootRef.child("grocery-items")
         
         // 4
         let milkRef = itemsRef.child("milk")
         
         // 5
         print(rootRef.key)   // prints: ""
         print(childRef.key)  // prints: "grocery-items"
         print(itemsRef.key)  // prints: "grocery-items"
         print(milkRef.key)   // prints: "milk"*/
        
    }

    
    
    func addArtist(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refArtists.childByAutoId().key
        
        //creating artist with the given values
        let artist = ["id":key,
                      "artistName": nameTF.text! as String,
                      "artistGenre": numberTF.text! as String
        ]
        
        //adding the artist inside the generated unique key
        refArtists.child(key).setValue(artist)
        
        //displaying message
       updateDatabaseLabel.text = "Artist Added"
    }

    @IBAction func send_FireBase_Button_Tapped(_ sender: UIButton) {
       
        self.addArtist()
        self.nameTF.text = ""
        self.numberTF.text = ""
    
    }
     func deleteArtist(id:String){
     refArtists.child(id).setValue(nil)
     self.firebaseTableView.reloadData()
     //displaying message
     updateDatabaseLabel.text = "Artist Deleted"
     }
    func updateArtist(id:String, name:String, genre:String){
     //creating artist with the new given values
     let artist = ["id":id,"artistName": name,"artistGenre": genre]
     
     //updating the artist using the key of the artist
     refArtists.child(id).setValue(artist)
        self.firebaseTableView.reloadData()
     
     //displaying message
     updateDatabaseLabel.text = "Artist Updated"
     }
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirebaseTVC", for: indexPath) as! FirebaseTVC
        
        //the artist object
        let artist: ArtistModel
       
        //getting the artist of selected position
        artist = artistList[indexPath.row]
        cell.nameLabel.text = artist.name
        cell.gendreLabel.text = artist.genre
        cell.firebaseView.layer.borderColor = UIColor.gray.cgColor
        cell.firebaseView.layer.borderWidth = 1.0
        cell.firebaseView.layer.cornerRadius = 10.0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist  = artistList[indexPath.row]
        let alertController = UIAlertController(title: artist.name, message: "Give new values to update ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting artist id
            let id = artist.id
            
            //getting new values
            let name = alertController.textFields?[0].text
            let genre = alertController.textFields?[1].text
            
            //calling the update method to update artist
            self.updateArtist(id: id!, name: name!, genre: genre!)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            //deleting artist
            self.deleteArtist(id: artist.id!)
        }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = artist.name
        }
        alertController.addTextField { (textField) in
            textField.text = artist.genre
        }
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

