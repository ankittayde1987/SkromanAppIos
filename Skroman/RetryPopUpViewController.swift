//
//  RetryPopUpViewController.swift
//  Skroman
//
//  Created by Admin on 17/06/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
protocol RetryPopUpViewControllerDelegate {
    func retryAPI()
}
class RetryPopUpViewController: UIViewController {

    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblError: UILabel!
    var delegate : RetryPopUpViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.contentSizeInPopup = CGSize.init(width: SCREEN_SIZE.width - 60, height: 103)
        self.popupController?.containerView.layer.cornerRadius = 3.0
        self.popupController?.containerView.layer.borderWidth = 1.0
        self.popupController?.containerView.layer.borderColor = UICOLOR_POPUP_BORDER.cgColor
        
        self.popupController?.navigationBarHidden = true
    }
    
    
    @IBAction func tappedOnRetry(_ sender: Any) {
        self.popupController?.dismiss(completion: {
            self.delegate?.retryAPI()
        })
    }
    
}
