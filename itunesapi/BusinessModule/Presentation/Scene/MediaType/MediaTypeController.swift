//
//  MediaTypeController.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import UIKit

class MediaTypeController: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let typeList:[MediaTypeModel] = AppUtils.typeList
     
    var selectedItem:[MediaTypeModel] = []
    
    var backHandler:(([MediaTypeModel])->())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.basicConfig()
        self.registerTableView()
       
    }


    private func basicConfig(){
        self.view.backgroundColor = ColorUtils.blackColor
        tableView.backgroundColor = ColorUtils.blackColor
        
        navigationView.titleLabel.text = "Media"
        navigationView.backHandler = {
            
            if let handler = self.backHandler{
                    handler(self.selectedItem)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
   
    private func registerTableView(){
        
        tableView.register(UINib(nibName: "\(MediaTypeCell.self)", bundle: .main), forCellReuseIdentifier: MediaTypeCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension MediaTypeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaTypeCell.identifier, for: indexPath) as! MediaTypeCell
   
        cell.title = typeList[indexPath.item].key
        
        if selectedItem.contains(typeList[indexPath.item]) {
            cell.imageSelect.isHidden = false
        }else {
            cell.imageSelect.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedItem.contains(typeList[indexPath.item]) {
            if let index = selectedItem.firstIndex(where: {$0 == typeList[indexPath.item] }) {
                selectedItem.remove(at: index)
            }
        }else {
            selectedItem.append(typeList[indexPath.item])
        }
        self.tableView.reloadData()
    }
    
}
