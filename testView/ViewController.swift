//
//  ViewController.swift
//  testView
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Saiwarun.Y. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    let fileName = "db2.sqlite"
    let fileManager = FileManager.default
    let dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?

    @IBOutlet weak var textView: UITextView!
    @IBAction func deleteData(_ sender: Any) {
        let alert = UIAlertController(
            title: "Delete",
            message: "ใส่ข้อมูลให้ครบทุกช่อง",
            preferredStyle: .alert
        )
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "id"
            tf.font = UIFont.systemFont(ofSize: 18)
            tf.keyboardType = .phonePad
        })
        
        let btCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        let btOK = UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                guard let id = Int32(alert.textFields!.first!.text!) else { return }
                self.sql = "delete from peoples where id = \(id)"
                sqlite3_exec(self.db, self.sql, nil, nil, nil)
                self.select()
        })
        alert.addAction(btCancel)
        alert.addAction(btOK)
        present(alert, animated:true, completion: nil)

    }
    @IBAction func editData(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbURL = try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
            ).appendingPathComponent(fileName)
        let openDb = sqlite3_open(dbURL.path, &db)
        if openDb != SQLITE_OK {
            print("Opening Database Error!")
            return
        }
        sql = "CREATE TABLE IF NOT EXISTS peoples (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, date TEXT)"
        let createTb = sqlite3_exec(db, sql, nil, nil, nil)
        if createTb != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            print(err)
        }
        sql = "INSERT INTO peoples (id, name, phone, date) VALUES ('1', 'Somchai Pairuea', '0841410563', 'aaaa')"
        sqlite3_exec(db, sql, nil, nil, nil)
        
        select()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func select(){
        sql = "SELECT * FROM peoples"
        sqlite3_prepare(db, sql, -1, &pointer, nil)
        textView.text = ""
        var id: Int32
        var name: String
        var phone: String
        var date: String
        
        while(sqlite3_step(pointer) == SQLITE_ROW){
            id = sqlite3_column_int(pointer, 0)
            textView.text?.append("id: \(id)\n")
            
            name = String(cString: sqlite3_column_text(pointer, 1))
            textView.text?.append("name: \(name)\n")
            
            phone = String(cString: sqlite3_column_text(pointer, 2))
            textView.text?.append("phone: \(phone)\n")
            
            date = String(cString: sqlite3_column_text(pointer, 3))
            textView.text?.append("date: \(date)\n\n")
        }
    }

}

