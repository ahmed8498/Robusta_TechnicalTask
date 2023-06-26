//
//  RepositoriesAPI.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation

enum RepositoriesAPI {
    case getRepositories
    case getRepositoryMoreInfo(repoFullName: String)
}


extension RepositoriesAPI: NetworkRequest {
    var baseURL: URL {
        switch self {
        case .getRepositories, .getRepositoryMoreInfo:
            let baseURLString = "https://api.github.com/"
            if let url = URL(string: baseURLString) {
                return url
            } else {
                fatalError("Could not find \(baseURLString)")
            }
            
        }
    }
    
    var path: String {
        switch self {
        case .getRepositories:
            return "repositories"
        case .getRepositoryMoreInfo(let repoFullName):
            return "repos/\(repoFullName)"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getRepositories, .getRepositoryMoreInfo:
            return .get
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    

    
}
