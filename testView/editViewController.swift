//
//  SecondViewController.swift
//  testView
//
//  Created by Admin on 4/3/2562 BE.
//  Copyright © 2562 Saiwarun.Y. All rights reserved.
//

import UIKit
import SQLite3

class editViewController: UIViewController {
    let fileName = "db2.sqlite"
    let fileManager = FileManager.default
    let dbPath = String()
    var sql = String()
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var pointer: OpaquePointer?
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var seletedDate: UILabel!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var id: UITextField!

    @IBAction func editData(_ sender: Any) {
        let n = name.text! as NSString
        let p = phone.text! as NSString
        
        let currentDate = date.date
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "dd/MM/YYYY"
        let currentDateText = myFormatter.string(from: currentDate)
        seletedDate.text = currentDateText
        
        self.sql = "insert into peoples values (null, ?, ?, ?)"
        sqlite3_prepare(self.db, self.sql, -1, &self.stmt, nil)
        sqlite3_bind_text(self.stmt, 1, n.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 2, p.utf8String, -1, nil)
        sqlite3_bind_text(self.stmt, 3, seletedDate.text, -1, nil)
        sqlite3_step(self.stmt)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        seletedDate.text = ""
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
    }
    
}
