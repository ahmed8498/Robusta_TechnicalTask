//
//  RepositoriesViewModel.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 24/06/2023.
//

import Foundation
import Combine

class RepositoriesViewModel {
    @Published var error: CustomError?
    @Published var paginatedListOfRepositories: [Repository]?
    var fullListOfRepositories: [Repository] = []
    var filteredListOfRepositories: [Repository] = []
    
    var repo = RepositoriesDataRepository()
    var cancellables = Set<AnyCancellable>()
    
    let pageSize = 10
    var pageNumber = 1
    var searchString = ""
    
    func getRepositories() {
        repo.getRepositories()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error}
            }, receiveValue: { [weak self] repositoriesListResponse in
                self?.fullListOfRepositories = repositoriesListResponse ?? []
                if self?.fullListOfRepositories.count ?? 0  <= self?.pageSize ?? 0 {
                    self?.paginatedListOfRepositories = self?.fullListOfRepositories ?? []
                } else {
                    self?.paginatedListOfRepositories = Array(self?.fullListOfRepositories[0..<(self?.pageSize ?? 0)] ?? [])
                }
                self?.filteredListOfRepositories = self?.fullListOfRepositories ?? []
            })
            .store(in: &cancellables)
    }
    
    func getNextRepositories() {
        guard let paginatedListOfRepositories = paginatedListOfRepositories else {return}
        let countDifference = filteredListOfRepositories.count - paginatedListOfRepositories.count
        if countDifference == 0 {
            return
        }
        if countDifference >= pageSize {
            let startIndex = pageSize * pageNumber
            pageNumber += 1
            let endIndex = pageSize * pageNumber
            self.paginatedListOfRepositories?.append(contentsOf: self.filteredListOfRepositories[startIndex..<endIndex])
        } else {
            let startIndex = pageSize * pageNumber
            let endIndex = startIndex + countDifference
            self.paginatedListOfRepositories?.append(contentsOf: self.filteredListOfRepositories[startIndex..<endIndex])
        }
    }
    
    func shouldLoadMoreData() -> Bool {
        (paginatedListOfRepositories?.count ?? 0) != filteredListOfRepositories.count
    }
    
    func getPaginatedListCount() -> Int {
        return paginatedListOfRepositories?.count ?? 0
    }
    
    func getPaginatedRepository(at index: Int) -> Repository? {
        return paginatedListOfRepositories?[index]
    }
    
    func updateSearchString(withString string: String) {
        searchString = string
        pageNumber = 0
        if string != "" {
            filteredListOfRepositories = fullListOfRepositories.filter({$0.name!.lowercased().contains(searchString.lowercased())})
        } else {
            filteredListOfRepositories = fullListOfRepositories
        }
        paginatedListOfRepositories = []
        getNextRepositories()
    }
}
