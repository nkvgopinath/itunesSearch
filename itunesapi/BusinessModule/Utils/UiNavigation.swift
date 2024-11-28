//
//  UiNavigation.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//
import UIKit

extension UIViewController{
    
    
    func showAlert(message: String, title: String = "Error") {
        DispatchQueue.main.async{
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
