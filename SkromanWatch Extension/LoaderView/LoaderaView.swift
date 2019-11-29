//
//  LoaderaView.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 25/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation


class LoaderaView: WKInterfaceController {
    
    @IBOutlet var loader: WKInterfaceImage!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.responseReceived),
            name: NSNotification.Name(rawValue: "ResponseReceived"),
            object: nil)

    }

    
    override func willActivate() {
        super.willActivate()

        self.showLoader()
    }

    
    func showLoader() {

        loader.stopAnimating()
        loader.setHidden(true)
        loader.setHidden(false)
        loader.setImageNamed("loader")
        loader.startAnimatingWithImages(in: NSRange(location: 1,
                                                    length: 8), duration: 0.8, repeatCount: -1)
    }
    
    @objc func responseReceived(notification:NSNotification){
        
        self.dismissLoader()
    }

    func dismissLoader() {

        loader.stopAnimating()
        loader.setHidden(true)
        
        self.dismiss()
        self.popToRootController()
        self.pop()
    }


}
