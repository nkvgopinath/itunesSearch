//
//  Coordinate.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//


import UIKit

protocol Coordinate {
    associatedtype Screen
    associatedtype View: UIViewController

    var viewController: View? { get set }

    func showScreen(_ screen: Screen)
    func showError(_ error: String)
}
