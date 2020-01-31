//
//  ViewController.swift
//  sqlite database
//
//  Created by Ajay Vandra on 1/31/20.
//  Copyright © 2020 Ajay Vandra. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    var database : Connection!
    let userTable = Table("users")
    let ID = Expression<Int>("ID")
    let name = Expression<String>("name")
    let email = Expression<String>("email")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        }catch{
            print(error)
        }
        
        
    }

    @IBAction func createButton(_ sender: UIButton) {
        let createTable = self.userTable.create { (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.name)
            table.column(self.email, unique: true)
        }
        do{
            try self.database.run(createTable)
            print("table created")
        }catch{
            print(error)
        }
    }
    
    @IBAction func insertButton(_ sender: UIButton) {
    
        var textField = UITextField()
               let alert = UIAlertController(title: "Insert", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
                let name = alert.textFields?.first?.text
                let email = alert.textFields?.last?.text
                let insertUser = self.userTable.insert(self.name <- name!,self.email <- email!)
                do{
                    try self.database.run(insertUser)
                }catch{
                    print(error)
                }
                print(name!)
                print(email!)
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Name"
                   textField = alertTextField
               }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Email"
            textField = alertTextField
        }
        
        
               alert.addAction(action)
               present(alert, animated: true, completion: nil)
    }
    @IBAction func updateButton(_ sender: UIButton) {
        
              var textField = UITextField()
                     let alert = UIAlertController(title: "Update", message: "", preferredStyle: .alert)
                     let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
                          let name = alert.textFields?.first?.text
                                        let email = alert.textFields?.last?.text
                        print(name!)
                        print(email!)
                     }
                     alert.addTextField { (alertTextField) in
                         alertTextField.placeholder = "Name"
                         textField = alertTextField
                     }
              alert.addTextField { (alertTextField) in
                  alertTextField.placeholder = "Email"
                  textField = alertTextField
              }
                     alert.addAction(action)
                     present(alert, animated: true, completion: nil)
    }
    @IBAction func deleteButton(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Delete", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "delete", style: .default) { (UIAlertAction) in

            let userId = Int(textField.text!)
            let user = self.userTable.filter(self.ID == userId!)
            let deleteUser = user.delete()
            do{
                try self.database.run(deleteUser)
            }catch{
                print(error)
            }
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Id"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    @IBAction func listButton(_ sender: UIButton) {
        let users = try! self.database.prepare(userTable)
        for user in users{
            print("id:\(user[ID]),name:\(user[name]),email:\(user[email])")
        }
    }
}

