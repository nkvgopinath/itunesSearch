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
        DispatchQueue.main.async {
            let sview = UIView(frame: UIScreen.main.bounds)
        //    sview.backgroundColor = .clear
            sview.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = ColorUtils.whiteColor
            activityIndicator.hidesWhenStopped = true
            activityIndicator.tag = LOADER_TAG
            activityIndicator.center = sview.center
            
            sview.addSubview(activityIndicator)
            sview.tag = LOADER_TAG
    
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(sview)
            activityIndicator.startAnimating()
        }
    }

    func hideCustomLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view.isUserInteractionEnabled = true
            for sView in self.view.subviews where sView.tag == LOADER_TAG {
                sView.removeFromSuperview()
            }
        }
    }
}
