//
//  iTunesSearchController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit

class iTunesSearchController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var searchTextfield: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var filterData:[MediaTypeModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.basicConfig()
        self.registCollectionView()
        self.configureUiTest()
        self.checkRootDetection()
    }
    
    func checkRootDetection(){
        if UIDevice().isJailBroken {
            self.showAlert(message: "Device Issue", title: "This is jail broken device")
        }
    }
    
    func configureUiTest(){
        searchTextfield.accessibilityIdentifier = "searchTextField"
        submitButton.accessibilityIdentifier = "submitButton"
        collectionView.accessibilityIdentifier = "collectionView"
    }
    
    
    private func registCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 3, right: 10)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "\(TitleCell.self)", bundle: .main), forCellWithReuseIdentifier: TitleCell.identifier)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        collectionView.addGestureRecognizer(gesture)
        
        
    }
    
    private func basicConfig(){
        backgroundView.backgroundColor = .black
        submitButton.layer.cornerRadius = 6
        searchTextfield.backgroundColor = ColorUtils.grayColor
        collectionView.backgroundColor = ColorUtils.grayColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if  let searchKeyword = searchTextfield.text, searchKeyword.count > 0 {
            let controller = iTunesControllerView()
            let coordinator = iTunesCoordinator()
            let repository = iTuneSearchUseCaseRepository(APIClient())
            let viewModel = iTunesViewModel(repositoryProvider: repository, coordinatorProvider: coordinator, filterProvider: filterData)
            controller.viewModel = viewModel
            viewModel.getApi(searchKeyword: searchKeyword)
            coordinator.viewController = controller
            self.navigationController?.pushViewController(controller, animated: true)
        }else {
            self.showAlert(message: "Please enter the search data" )
        }
    }
    
    
    @objc func handleTap() {
        self.moveToMedia()
    }
    
    
    private  func moveToMedia(){
        let vc = MediaTypeController()
        vc.selectedItem = filterData
        vc.backHandler = { mediaType in
            self.filterData = mediaType
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension iTunesSearchController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = filterData[indexPath.item].value
        let width = (value as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: .usesLineFragmentOrigin, context: nil).width
        
        return CGSize(width: width + 30, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToMedia()
    }
    
}



extension iTunesSearchController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
        cell.title = filterData[indexPath.item].key
        cell.setRadiusCorner(radius: 13, color: ColorUtils.lightGrayColor)
        cell.setLayer(borderWidth: 0.5, color : UIColor.white)
        
        return cell
        
    }
    
    
}
