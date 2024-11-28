//
//  iTunesGridController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit
import Combine

class iTunesGridController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: iTunesViewModel?
    
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        registCollectionView()
        self.bindViewModel()
        self.testCases()
    }

    func testCases(){
        self.view.accessibilityIdentifier = "iTunesGridControllerView"

    }

    private func bindViewModel(){
        viewModel?.$iTunesSearchModel
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] _ in
                      self?.collectionView.reloadData()
                   }
                   .store(in: &cancellables)
    }
    
    
    private func registCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = ColorUtils.blackColor
        collectionView.backgroundColor = ColorUtils.blackColor
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 3, right: 10)
        
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "\(GridCollectionCell.self)", bundle: .main), forCellWithReuseIdentifier: GridCollectionCell.identifier)
    
        collectionView.register(UINib(nibName: "TitleCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleCell")

    }
    
}

extension iTunesGridController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = (collectionView.frame.size.width ) / 4.0
        let height:CGFloat = width + (width/2)
        return CGSize(width: width, height: height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.moveDetailScreen(indexPath: indexPath)
    }
}

extension iTunesGridController : UICollectionViewDataSource{
   

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleCell.identifier)", for: indexPath) as? TitleCell else {
                return UICollectionReusableView()
            }
        header.title = self.viewModel?.iTunesSearchModel[indexPath.section].title
        header.titleLable.textAlignment = .left
        header.backgroundColor = ColorUtils.grayColor
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.iTunesSearchModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.iTunesSearchModel[section].data.count ?? 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionCell.identifier, for: indexPath) as? GridCollectionCell else {
             return UICollectionViewCell()
        }
        cell.holderView.tileLabel.text = self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].collectionName ?? self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].artistName ?? ""
        cell.holderView.imageView.image = nil
        if let imageUrlString = self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].artworkUrl100 {
            ImageCacheManagement.instance.getImagefromUrl(urlImage: imageUrlString) { imagedata, cached in
            
                    DispatchQueue.main.async {
                        if let img = imagedata {
                            if let currentCell = collectionView.cellForItem(at: indexPath) as? GridCollectionCell {
                                currentCell.holderView.imageView.image = img
                                currentCell.holderView.imageView.layoutIfNeeded()
                            }
                        }
                }
            }
        }
        
        cell.backgroundColor = ColorUtils.blackColor

        return cell
    }
}
    
