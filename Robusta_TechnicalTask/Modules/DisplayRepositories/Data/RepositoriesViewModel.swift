//
//  RepositoriesViewModel.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 24/06/2023.
//

import UIKit
import Combine

class RepositoriesViewModel {
    @Published var error: CustomError?
    @Published var paginatedListOfRepositories: [Repository]?
    @Published var downloadedImageResponse: UIImage?
    @Published var getRepositoryMoreInfoResponse:  RepositoryMoreInfo?
    var fullListOfRepositories: [Repository] = []
    var filteredListOfRepositories: [Repository] = []
    
    var repo = RepositoriesDataRepository()
    var cancellables = Set<AnyCancellable>()
    
    let pageSize = 10
    var pageNumber = 1
    var searchString = ""
    private var selectedRepoositoryIndex: Int?
    
    func getRepositories() {
        repo.getRepositories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error}
            }, receiveValue: { [weak self] repositoriesListResponse in
                self?.fullListOfRepositories = repositoriesListResponse ?? []
                self?.filteredListOfRepositories = self?.fullListOfRepositories ?? []
                
                self?.paginatedListOfRepositories = Array(self?.fullListOfRepositories[0..<(self?.pageSize ?? 0)] ?? [])
            })
            .store(in: &cancellables)
    }
    
    func downloadRepositoryImage(atIndex index: Int) -> AnyPublisher<UIImage, CustomError> {
        let subject = PassthroughSubject<UIImage, CustomError>()
        guard let imageURLString = getPaginatedRepository(at: index)?.owner?.imageURL, let imageURL = URL(string: imageURLString) else {return Fail(error: CustomError.generalError).eraseToAnyPublisher()}
        
        repo.downloadRepositoryImage(url: imageURL)
            .sink { completion in
                if case let .failure(error) = completion {
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { [weak self] imageResponse in
                self?.paginatedListOfRepositories?[index].owner?.image = imageResponse
                subject.send(imageResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
            
        }
    
    func getRepositoryMoreInfo(atIndex index: Int) -> AnyPublisher<RepositoryMoreInfo, CustomError> {
        let subject = PassthroughSubject<RepositoryMoreInfo, CustomError>()

        guard let repositoryFullName = getPaginatedRepository(at: index)?.fullName else {return Fail(error: CustomError.generalError).eraseToAnyPublisher()}
        
        repo.getRepositoryMoreInfo(repositoryFullName: repositoryFullName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error}
            }, receiveValue: { [weak self] repoMoreInfoResponse in
                self?.paginatedListOfRepositories?[index].moreInfo = repoMoreInfoResponse
                subject.send(repoMoreInfoResponse)
            })
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
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
    
    func isOwnerImageDownloaded(atIndex index: Int) -> Bool {
        return paginatedListOfRepositories?[index].owner?.image != nil
    }
    
    func isRepoMoreInfoFetched(atIndex index: Int) -> Bool {
        return paginatedListOfRepositories?[index].moreInfo != nil
    }
    
    
    func updateRepositoryMoreInfo(atIndex index: Int, withMoreInfo moreInfo: RepositoryMoreInfo) {
        paginatedListOfRepositories?[index].moreInfo = moreInfo
    }
    
    func setSelectedRepositoryIndex(index: Int) {
        selectedRepoositoryIndex = index
    }
    
    func getSelectedRepository() -> Repository? {
        guard let selectedRepoositoryIndex = selectedRepoositoryIndex else {return nil}
        return paginatedListOfRepositories?[selectedRepoositoryIndex]
    }
}
