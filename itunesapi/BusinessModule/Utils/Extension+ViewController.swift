//
//  Extension+ViewController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//



import UIKit
let LOADER_TAG = 1111123333334

extension UIViewController {

    
    func showCustomLoader() {
        hideCustomLoader()
        DispatchQueue.main.async {
          
            let sview = UIView(frame: UIScreen.main.bounds)
            sview.backgroundColor = .clear
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = ColorUtils.whiteColor
            activityIndicator.hidesWhenStopped = true
            activityIndicator.tag = LOADER_TAG
            activityIndicator.center = sview.center
            
            sview.addSubview(activityIndicator)
            sview.tag = LOADER_TAG
    
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(sview)

        }
    }

    func hideCustomLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            if let applnWindow = UIApplication.shared.keyWindow {
                for sView in applnWindow.subviews where sView.tag == LOADER_TAG {
                    sView.removeFromSuperview()
                }
            }
        }
    }
}
