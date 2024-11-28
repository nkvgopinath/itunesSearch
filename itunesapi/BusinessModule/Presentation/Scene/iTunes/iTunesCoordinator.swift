//
//  iTunesCoordinator.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//
import UIKit

final class iTunesCoordinator: Coordinate {
    
    weak var viewController: iTunesControllerView?

    init(viewController: iTunesControllerView) {
         self.viewController = viewController
       }

        
    func showScreen(_ screen: Screen) {
        switch screen {
        case .detailScreen:
            let vc = iTunesDetailsController()
            vc.viewModel = self.viewController?.viewModel
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .alert(let message):
            viewController?.showAlert(message: message)
            break
            
        case .openWebPage(let webUrl):
            let vc = WebViewConroller()
            vc.weburl = webUrl
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    func showError(_ error: String) {
        viewController?.showAlert(message: error)
    }
    
}


extension iTunesCoordinator {
    enum Screen {
        case detailScreen, alert(message: String),openWebPage(webUrl: String)
    }
}
