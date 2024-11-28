//
//  SplashController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline:.now()+4 , execute: {
            self.moveToSearch()
        })
    }

    private func moveToSearch(){
        
        let vc = iTunesSearchController()
        self.navigationController?.pushViewController(vc, animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
