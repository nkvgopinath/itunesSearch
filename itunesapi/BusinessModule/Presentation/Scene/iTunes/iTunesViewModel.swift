//
//  iTunesViewModel.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import Combine
import UIKit

class iTunesViewModel {
       
    private let repository: iTuneSearchUseCaseRepository?

    private let coordinator: iTunesCoordinator?
    
    @Published var iTunesSearchModel: [ItunesCategoryModel]
    
    private let filter: [MediaTypeModel]
    
     var selectedData:iTunesResult?
    
    init(repositoryProvider:iTuneSearchUseCaseRepository,coordinatorProvider:iTunesCoordinator, filterProvider:[MediaTypeModel]){
        repository = repositoryProvider
        coordinator = coordinatorProvider
        iTunesSearchModel = []
        filter = filterProvider
    }
    
    
    func openWebPage(){
        let url = selectedData?.artistViewUrl ?? selectedData?.collectionViewUrl ?? selectedData?.trackViewUrl
        if let previewUrl = url {
            self.coordinator?.showScreen(.openWebPage(webUrl: previewUrl))
        }
    }
    
    func moveDetailScreen(indexPath: IndexPath){
        selectedData = iTunesSearchModel[indexPath.section].data[indexPath.row]
        coordinator?.showScreen(.detailScreen)
    }
    
    func getApi(searchKeyword: String){
        
        self.coordinator?.viewController?.showLoader()

        let tempFilter = filter.count == 0 ? AppUtils.typeList : filter

        repository?.fetchAllMedia(searchTerm: searchKeyword, mediatypes: tempFilter) { response in
            self.coordinator?.viewController?.hideLoader()
            switch response{
            case .success(let response):
                if  response.count > 0 {
                    self.iTunesSearchModel = response
                }else {
                    self.coordinator?.showScreen(.alert(message: "No data found"))
                }
            case .failure(let error):
                self.coordinator?.showError(error.localizedDescription)
            }
        }
    }
    
}


