//
//  ViewController.swift
//  PMNetworking_Mac_Example
//
//  Created by Yanfeng Zhang on 4/30/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import PMNetworking


class DoHMail : DoH, DoHConfig {
    //defind your default host
    var defaultHost: String = ""
    //defind your query host
    var apiHost : String = ""
    //singleton
    static let `default` = try! DoHMail()
}



class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let host = DoHMail.default.getHostUrl()        
        print(host)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

