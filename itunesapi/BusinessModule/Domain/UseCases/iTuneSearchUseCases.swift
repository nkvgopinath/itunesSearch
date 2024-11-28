//
//  iTuneSearchUseCases.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import Foundation

protocol iTuneSearchUseCaseProtocol {
    
    func searchiTunes(searchKeyword:String,media:String,completion: @escaping(Result<iTunesDataModel, Error>) -> Void)
    func fetchAllMedia(searchTerm: String,mediatypes:[MediaTypeModel], completion: @escaping(Result<[ItunesCategoryModel], Error>) -> Void)
}


final class iTuneSearchUseCaseRepository {
    
    let request: APIClient
    
    init(_ apiProvider: APIClient) {
        self.request = apiProvider
    }
}

extension iTuneSearchUseCaseRepository: iTuneSearchUseCaseProtocol {
    
    func fetchAllMedia(searchTerm: String,mediatypes:[MediaTypeModel], completion: @escaping (Result<[ItunesCategoryModel], any Error>) -> Void) {
        let group = DispatchGroup()
        var finalList:[ItunesCategoryModel] = []
        var errorAppear:Error?
        
        for mediaType in mediatypes {
            group.enter()
            searchiTunes(searchKeyword: searchTerm, media: mediaType.value) { response in
                switch response{
                case .success(let response):
                    if let count =  response.resultCount, count > 0 {
                        if let result = response.results {
                            finalList.append(ItunesCategoryModel(title: mediaType.key, data: result))
                        }
                    }
                    group.leave()
                    
                case .failure(let error):
                    errorAppear = error
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = errorAppear {
                completion(.failure(error))
            }else {
                if finalList.count > 0 {
                    completion(.success(finalList))
                }
            }
        }
        
    }
    
    func searchiTunes(searchKeyword: String, media:String = "", completion: @escaping (Result<iTunesDataModel, any Error>) -> Void) {
        
        let path = APIConstants.search
        let query = ["term": searchKeyword, "media": media]
        let req = APIRequest(method: .get, path: path,  fullPath: false, queryItems: query)
        
        request.perform(req, iTunesDataModel.self) { response  in
            switch response {
            case .success(let response):
                print(response)
                completion(.success(response))
            case .failure(let err):
                print(err)
                completion(.failure(err))
            }
        }
    }    
    
}
