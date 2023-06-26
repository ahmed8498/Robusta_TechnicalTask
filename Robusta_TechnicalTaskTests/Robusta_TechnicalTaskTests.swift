//
//  Robusta_TechnicalTaskTests.swift
//  Robusta_TechnicalTaskTests
//
//  Created by Ahmed Mohamed on 26/06/2023.
//

import XCTest
@testable import Robusta_TechnicalTask

final class Robusta_TechnicalTaskTests: XCTestCase {

    var viewModel: RepositoriesViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = RepositoriesViewModel()
        var repositoriesArray: [Repository] = []
        for i in 0..<10 {
            let tempRepo = Repository()
            tempRepo.id = i
            tempRepo.name = "Name \(i)"
            tempRepo.owner = RepositoryOwner(id: i, name: "Owner \(i)", imageURL: "", image: nil)
            repositoriesArray.append(tempRepo)
        }
        
        viewModel.filteredListOfRepositories = repositoriesArray
        viewModel.paginatedListOfRepositories = repositoriesArray.dropLast(2)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }



    
    func testShouldLoadMoreData() {
        XCTAssertTrue(viewModel.shouldLoadMoreData())
    }
    
    func testIsOwnerImageDownloaded() {
        XCTAssertFalse(viewModel.isOwnerImageDownloaded(atIndex: 0))
        viewModel.paginatedListOfRepositories?[0].owner?.image = UIImage.add
        XCTAssertTrue(viewModel.isOwnerImageDownloaded(atIndex: 0))
    }
    
    func testIsMoreInfoDownloaded() {
        XCTAssertFalse(viewModel.isRepoMoreInfoFetched(atIndex: 0))
        viewModel.paginatedListOfRepositories?[0].moreInfo = RepositoryMoreInfo()
        XCTAssertTrue(viewModel.isRepoMoreInfoFetched(atIndex: 0))
    }
    
    

}
