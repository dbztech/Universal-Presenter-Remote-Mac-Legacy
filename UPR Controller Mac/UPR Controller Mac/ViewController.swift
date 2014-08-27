//
//  ViewController.swift
//  UPR Controller Mac
//
//  Created by Brendan Boyle on 8/26/14.
//  Copyright (c) 2014 DBZ Technology. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
                            
    @IBOutlet weak var tabController: NSTabView!
    @IBOutlet weak var token1: NSTextField!
    @IBOutlet weak var token2: NSTextField!
    @IBOutlet weak var token3: NSTextField!
    @IBOutlet weak var token4: NSTextField!
    @IBOutlet weak var token5: NSTextField!
    @IBOutlet weak var token6: NSTextField!
    @IBOutlet weak var connectButton: NSButton!
    
    var tokenFields: [String] = ["","","","","",""]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                                    
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
        
        
    }
    
    @IBAction func connectButton(sender: AnyObject) {
    }
    
    override func controlTextDidChange(obj: NSNotification!) {
        if token1.stringValue != tokenFields[0] {
            token2.becomeFirstResponder()
        }
        if token2.stringValue != tokenFields[1] {
            token3.becomeFirstResponder()
        }
        if token3.stringValue != tokenFields[2] {
            token4.becomeFirstResponder()
        }
        if token4.stringValue != tokenFields[3] {
            token5.becomeFirstResponder()
        }
        if token5.stringValue != tokenFields[4] {
            token6.becomeFirstResponder()
        }
        if token6.stringValue != tokenFields[5] {
            token6.resignFirstResponder()
        }
        
        tokenFields[0] = token1.stringValue;
        tokenFields[1] = token2.stringValue;
        tokenFields[2] = token3.stringValue;
        tokenFields[3] = token4.stringValue;
        tokenFields[4] = token5.stringValue;
        tokenFields[5] = token6.stringValue;
        
    }

}

