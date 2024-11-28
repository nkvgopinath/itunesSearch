//
//  iTunesControllerView.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit

class iTunesControllerView: UIViewController  {

    @IBOutlet weak var navigation: NavigationBarView!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    @IBOutlet weak var viewHolder: UIView!
    
    var viewModel: iTunesViewModel?
    
    var vc: [UIViewController] = []
    
    var pageController: UIPageViewController!

    var selectedIndex:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testCase()
        self.basicConfig()
        self.setupPageConroller()
        self.testCase()
       
    }
    
    func testCase(){
        self.view.accessibilityIdentifier = "iTunesControllerView"
        segmentController.accessibilityIdentifier = "segmentedControl"
        viewHolder.accessibilityIdentifier = "viewHolder"
        navigation.backButton.accessibilityIdentifier = "Back"

    }
    func showLoader(){
        DispatchQueue.main.async {
            self.showCustomLoader()
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.async {
            self.hideCustomLoader()
        }
    }
    
    private func basicConfig() {
        viewHolder.backgroundColor = ColorUtils.blackColor
        self.view.backgroundColor = ColorUtils.blackColor

        segmentController.selectedSegmentTintColor = ColorUtils.lightGrayColor
        segmentController.backgroundColor = ColorUtils.grayColor
        segmentController.setTitleTextAttributes([.foregroundColor: ColorUtils.whiteColor], for: .normal)
        segmentController.setTitleTextAttributes([.foregroundColor: ColorUtils.whiteColor], for: .selected)
        
        navigation.titleLabel.text = "iTunes"
        navigation.backHandler = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private  func setupPageConroller(){
        let gridVc = iTunesGridController()
        let listVc = iTunesListController()
        gridVc.viewModel = self.viewModel
        listVc.viewModel = self.viewModel
        
        vc = [gridVc, listVc]
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       
        pageController.setViewControllers([vc[0]], direction: .forward, animated: true)
        pageController.view.frame = viewHolder.bounds
        viewHolder.addSubview(pageController.view)
        addChild(pageController)
        pageController.didMove(toParent: self)

    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func indexChanges(_ sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            pageController.setViewControllers([vc[0]], direction: .reverse, animated: true)
            pageController.view.frame = viewHolder.bounds
            viewHolder.addSubview(pageController.view)
            addChild(pageController)
            pageController.didMove(toParent: self)

            break
        case 1:
            pageController.setViewControllers([vc[1]], direction: .forward, animated: true)
            pageController.view.frame = viewHolder.bounds
            viewHolder.addSubview(pageController.view)
            addChild(pageController)
            pageController.didMove(toParent: self)

            break
        default: break
            
        }
    }
}
