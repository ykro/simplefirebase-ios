//
//  ViewController.swift
//  SimpleFirebase
//
//  Created by ykro on 8/14/16.
//  Copyright © 2016 Bit & Ik'. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    private let WORDS_CHILD: String = "words"
    private let MESSAGE_CHILD: String = "message"

    @IBOutlet weak var txtNotice: UITextView!
    @IBOutlet weak var inputWord: UITextField!
    @IBAction func didClickedSubmit(sender: UIButton) {
        if inputWord.text != nil && !inputWord.text!.isEmpty {
            let wordsReference: FIRDatabaseReference = FIRDatabase.database().reference().child(WORDS_CHILD)
            let newElementReference = wordsReference.childByAutoId()
            
            newElementReference.setValue(inputWord.text)
            inputWord.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database: FIRDatabase = FIRDatabase.database()
        let messageReference: FIRDatabaseReference = database.reference().child(MESSAGE_CHILD)
        messageReference.setValue("Hello World!")
        messageReference.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            guard snapshot.value is String else {
                print("Error: \(self.MESSAGE_CHILD) value is not a string")
                return
            }
            let msg: String = snapshot.value as! String
            self.txtNotice.text = msg
        })
        
        let wordsReference: FIRDatabaseReference = FIRDatabase.database().reference().child(WORDS_CHILD)
        wordsReference.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            let msg: String = snapshot.value as! String
            self.txtNotice.text = msg
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

