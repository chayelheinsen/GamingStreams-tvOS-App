//
//  TwitchAuthViewController.swift
//  GamingStreamsTVApp
//
//  Created by Brendan Kirchner on 10/15/15.
//  Copyright © 2015 Rivus Media Inc. All rights reserved.
//

import UIKit

class TwitchAuthViewController: QRCodeViewController {
    
    var UUID: String!
    
    convenience init() {
        let title = "Scan the QR code below or go to the link provided.\nOnce you have received your authentication code, enter it below."
        let uuid = String.randomStringWithLength(12)
        self.init(title: title, url: "http://streamcenterapp.com/oauth/twitch/\(uuid)")
        UUID = uuid
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func processCode() {
        guard let code = codeField.text else {
            print("no code")
            return
        }
        
        StreamCenterService.authenticateTwitch(withCode: code, andUUID: UUID) { (token, error) -> () in
            print(token)
            guard let token = token else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.titleLabel.text = "\(error)\nPlease ensure that your code is correct and press Process again."
                })
                return
            }
            TokenHelper.storeTwitchToken(token)
            self.delegate?.qrCodeViewControllerFinished(true, data: nil)
        }
    }

}
