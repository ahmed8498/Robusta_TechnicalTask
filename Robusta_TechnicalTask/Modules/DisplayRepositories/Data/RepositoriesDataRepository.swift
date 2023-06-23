//
//  RepositoriesDataRepository.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation
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
}
