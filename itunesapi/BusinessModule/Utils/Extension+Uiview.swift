//
//  Extension+Uiview.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//


import UIKit

extension UIView {
    private static var activityIndicatorTag = 888888

    func showActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor = .white) {
        if let existingIndicator = self.viewWithTag(UIView.activityIndicatorTag) as? UIActivityIndicatorView {
            existingIndicator.startAnimating()
            return
        }

        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.center = self.center
        activityIndicator.color = color
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tag = UIView.activityIndicatorTag

        let overlay = UIView(frame: self.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.tag = UIView.activityIndicatorTag + 1 // Unique tag for overlay

        DispatchQueue.main.async{
            self.addSubview(overlay)
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        if let activityIndicator = self.viewWithTag(UIView.activityIndicatorTag) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        self.viewWithTag(UIView.activityIndicatorTag + 1)?.removeFromSuperview() // Remove overlay
    }
    
    func setRadiusCorner(radius:CGFloat, color: UIColor = ColorUtils.whiteColor){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.backgroundColor = color.cgColor
    }
    
    func setLayer(borderWidth:CGFloat, color: UIColor = ColorUtils.lightGrayColor){
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
    }
}
