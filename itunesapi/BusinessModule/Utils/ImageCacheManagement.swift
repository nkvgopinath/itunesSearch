//
//  ImageCacheManagement.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//


import UIKit

import AVFoundation
import UIKit


class ImageCacheManagement {
    
    let imageCache = NSCache<AnyObject, AnyObject>()

    
    static let instance = ImageCacheManagement()
    
    func getImagefromUrl(urlImage: String, completion: @escaping(UIImage?, Bool)-> Void ){
        
        guard !urlImage.isEmpty else {
            completion(nil, false)
                   return
               }
        
        let imageUrlString = urlImage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !imageUrlString.isValidURL {
            let img = UIImage(named: imageUrlString)
            completion(img, false)
        }

        if let imageFromCache = imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
            completion(imageFromCache, true)
        }else {
            if let url = URL(string:imageUrlString) {

                let request = URLRequest(url: url)
                let session = URLSession.shared
                
                session.dataTask(with: request, completionHandler:{ (data, response, error) in
                    
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                        completion(nil, false)
                        return
                     }
                    
                    guard let imgData = data, let imageToCache = UIImage(data: imgData) else {
                        completion(nil, false)
                     return
                     }
                    self.imageCache.setObject(imageToCache, forKey: NSString(string: imageUrlString))
                    completion(imageToCache, false)
                   
                }).resume()
            }
        }
    }
}


extension String {
    var isValidURL: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        }catch {
            return false
        }
    }
}
