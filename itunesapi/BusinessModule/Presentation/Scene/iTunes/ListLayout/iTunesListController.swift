//
//  iTunesListController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit
import Combine

class iTunesListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: iTunesViewModel?
    
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.basicConfig()
        self.registerTableView()
        bindViewModel()
        self.testCases()
    }

    func testCases(){
        self.view.accessibilityIdentifier = "iTunesListControllerView"

    }
    
    private func bindViewModel(){
        viewModel?.$iTunesSearchModel
                   .receive(on: DispatchQueue.main)
                   .sink { [weak self] _ in
                       self?.tableView.reloadData()
                   }.store(in: &cancellables)
    }
    
    private func basicConfig(){
        self.view.backgroundColor = ColorUtils.blackColor
        tableView.backgroundColor = ColorUtils.blackColor
        
    }
   
    private func registerTableView(){
        
        tableView.register(UINib(nibName: "\(MediaTypeCell.self)", bundle: .main), forCellReuseIdentifier: MediaTypeCell.identifier)
        tableView.register(UINib(nibName: "\(ListTableViewCell.self)", bundle: .main), forCellReuseIdentifier: ListTableViewCell.identifier)

        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension iTunesListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: MediaTypeCell.identifier) as? MediaTypeCell else  {
            
            return UITableViewCell()
        }
        cell.imageSelect.isHidden = true
        cell.lineView.isHidden = true
        cell.title = self.viewModel?.iTunesSearchModel[section].title
        cell.mainView.backgroundColor =  ColorUtils.grayColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.iTunesSearchModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.iTunesSearchModel[section].data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.lableOne.text = self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].collectionName ??  ""
        cell.labelTwo.text = self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].artistName ?? ""
        cell.backgroundColor = ColorUtils.blackColor
        cell.imageTileView.imageView.image = nil
        cell.imageTileView.titleView.isHidden = true
        
        if let imageUrlString = self.viewModel?.iTunesSearchModel[indexPath.section].data[indexPath.row].artworkUrl100 {
            ImageCacheManagement.instance.getImagefromUrl(urlImage: imageUrlString) { imagedata, cached in
            
                    DispatchQueue.main.async {
                        if let img = imagedata {
                            if let currentCell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                                currentCell.imageTileView.imageView.image = img
                                currentCell.imageTileView.imageView.layoutIfNeeded()
                            }
                        }
                }
            }
        }
        
        cell.backgroundColor = ColorUtils.blackColor

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.viewModel?.moveDetailScreen(indexPath: indexPath)
    }
    
}
