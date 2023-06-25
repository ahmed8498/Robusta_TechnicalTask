//
//  RepositoriesDataRepository.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import UIKit
import Combine

class RepositoriesDataRepository {
    
    var cancellables = Set<AnyCancellable>()
    
    func getRepositories() -> AnyPublisher<[Repository]?, CustomError> {
        
        let subject = PassthroughSubject<[Repository]?, CustomError>()
        let getRepositoriesRequest = RepositoriesAPI.getRepositories
        
        NetworkManager.makeNetworkRequest(request: getRepositoriesRequest, responseModel: [Repository].self)
            .sink { completion in
                if case let .failure(error) = completion {
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { listOfRepositoriesResponse in
                subject.send(listOfRepositoriesResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
    
    func getRepositoryMoreInfo(repositoryFullName: String) -> AnyPublisher<RepositoryMoreInfo, CustomError> {
        let subject = PassthroughSubject<RepositoryMoreInfo, CustomError>()
        let getRepositoryMoreInfoRequest = RepositoriesAPI.getRepositoryMoreInfo(repoFullName: repositoryFullName)
        
        NetworkManager.makeNetworkRequest(request: getRepositoryMoreInfoRequest, responseModel: RepositoryMoreInfo.self)
            .sink { completion in
                if case let .failure(error) = completion {
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { repositoryMoreInfoResponse in
                subject.send(repositoryMoreInfoResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
    
    
    func downloadRepositoryImage(url: URL) -> AnyPublisher<UIImage, CustomError> {
        
        let subject = PassthroughSubject<UIImage, CustomError>()
        
        NetworkManager.downloadImage(fromUrl: url)
            .sink { completion in
                if case let .failure(error) = completion {
                    subject.send(completion: .failure(error))
                }
            } receiveValue: { imageResponse in
                subject.send(imageResponse)
            }
            .store(in: &cancellables)
        return subject.eraseToAnyPublisher()
    }
}
