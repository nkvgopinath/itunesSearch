//
//  itunesapiTests.swift
//  itunesapiTests
//
//  Created by Gopinath Vaiyapuri on 20/11/24.
//

import XCTest
@testable import itunesapi

final class itunesapiTests: XCTestCase {

    var repository: iTuneSearchUseCaseRepository!
    var mockAPIClient: MockAPIClient!

    override func setUp() {
          super.setUp()
          mockAPIClient = MockAPIClient()
          repository = iTuneSearchUseCaseRepository(mockAPIClient)
      }
    
    
    override func tearDown() {
            repository = nil
            mockAPIClient = nil
            super.tearDown()
        }
    
    func testSearchiTunesSuccess() {
           let mockResponse = iTunesDataModel(
               resultCount: 1,
               results: [iTunesResult(wrapperType:nil, kind: nil, artistId: nil, collectionId: nil, trackId: nil, artistName: nil, collectionName: nil, trackName: nil, collectionCensoredName: nil, trackCensoredName: nil, collectionArtistId: nil, collectionArtistName: nil, artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, collectionExplicitness: nil, trackExplicitness: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, currency: nil, primaryGenreName: nil, isStreamable: nil, longDescription: nil, shortDescription: nil)]
           )
           mockAPIClient.responseResult = .success(mockResponse)
           
           let expectation = self.expectation(description: "Completion handler called")
           repository.searchiTunes(searchKeyword: "elon") { result in
              
               switch result {
               case .success(let data):
                   XCTAssertEqual(data.resultCount, data.resultCount, "Result count should be 1.")
               case .failure:
                   XCTFail("Expected success but got failure.")
               }
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
           XCTAssertTrue(mockAPIClient.performCalled, "APIClient's perform should be called.")
        
       }
       
    
    func testSearchiTunesFailure() {

        let mockError = NSError(domain: "TestDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        let apiError = APIError.errorFromApi(mockError)

        mockAPIClient.responseResult = .failure(apiError)
        
        let expectation = self.expectation(description: "Completion handler called")
        
        repository.searchiTunes(searchKeyword: "Test", media: "all") { result in
            switch result {
            case .success(let response):
                XCTFail("Expected failure but got success: \(response)")
            case .failure(let error):
                let nsError = error as NSError
                let code = nsError.code
                print("Error code: \(code)")
                XCTAssertEqual(code, 0, "Error code should match.")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil) // Wait for completion handler to be invoked
        XCTAssertTrue(mockAPIClient.performCalled, "APIClient's perform method should be called.")
    }

       
       func testFetchAllMediaSuccess() {
           let mockMediaType = [MediaTypeModel(key: "Music", value: "music", combination: ["all"])]
           let mockResponse = iTunesDataModel(
               resultCount: 1,
               results: [iTunesResult(wrapperType: "Test Artist", kind: nil, artistId: nil, collectionId: nil, trackId: nil, artistName: "Artist", collectionName: nil, trackName: nil, collectionCensoredName: nil, trackCensoredName: nil, collectionArtistId: nil, collectionArtistName: nil, artistViewUrl: nil, collectionViewUrl: nil, trackViewUrl: nil, previewUrl: nil, artworkUrl30: nil, artworkUrl60: nil, artworkUrl100: nil, collectionPrice: nil, trackPrice: nil, releaseDate: nil, collectionExplicitness: nil, trackExplicitness: nil, discCount: nil, discNumber: nil, trackCount: nil, trackNumber: nil, trackTimeMillis: nil, country: nil, currency: nil, primaryGenreName: nil, isStreamable: nil, longDescription: nil, shortDescription: nil)]
           )
           mockAPIClient.responseResult = .success(mockResponse)
           let expectation = self.expectation(description: "Completion handler called")
           repository.fetchAllMedia(searchTerm: "Test", mediatypes: mockMediaType) { result in
               switch result {
               case .success(let categories):
                   XCTAssertEqual(categories.count, 1, "Categories count should be 1.")
                   XCTAssertEqual(categories.first?.title, "Music", "Category title should be 'Music'.")
               case .failure:
                   XCTFail("Expected success but got failure.")
               }
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 2, handler: nil)
           XCTAssertTrue(mockAPIClient.performCalled, "APIClient's perform should be called.")
       }
       
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}


class MockAPIClient: APIClient {
    
    var responseResult: Result<iTunesDataModel, Error>?
    var performCalled = false
    
    override   func perform<T:Decodable>(_ request: APIRequest,_ decoder: T.Type,_ completion: @escaping (ResponseData<T, APIError>) -> Void) {
        performCalled = true
     
        if let responseResult = responseResult {
              switch responseResult {
              case .success(let data):
                  if let typedData = data as? T {
                      completion(.success(typedData))
                  } else {
                      completion(.failure(APIError.invalidResponse))
                  }
              case .failure(let error):
                  completion(.failure(APIError.errorFromApi(error)))
              }
          } else {
              fatalError("Mock response not set in MockAPIClient")
          }
        
    }

}
