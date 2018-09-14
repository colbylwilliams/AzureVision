//
//  ViewController.swift
//  Example
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit
import AzureVision

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AzureVisionClient.shared.configure("OCP_APIM_SUBSCRIPTION_KEY", region: .eastUS)
    }

    @IBAction func buttonTouchUpInside(_ sender: Any) {
        (navigationController as? NavigationController)?.takePicture()
    }
}


extension UIViewController {
    
    func showErrorAlert (_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true) { }
    }
}
