//
//  NetworkManager.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import UIKit
import Combine

class NetworkManager {
    
//    Although the endpoint used does not require headers or parameters, the network manager class was created for generic call of other APIs if needed. Without such a handler, simply providing the URL to URLSession would do the job but the current Manager created provides a more general solution.
    
    
    class func makeNetworkRequest<T: Decodable>(request: NetworkRequest, responseModel: T.Type) -> AnyPublisher<T, CustomError> {
        
        var urlComponents = URLComponents(url: request.baseURL.appendingPathComponent(request.path, isDirectory: false), resolvingAgainstBaseURL: false)
         
        ///Used to add query parameters if required by the request
        if let queryParameters: [String: String] = request.queryParameters {
            var queryItems: [URLQueryItem] = []
            for key in queryParameters.keys {
                let queryItem = URLQueryItem(name: key, value: queryParameters[key])
                queryItems.append(queryItem)
            }
            urlComponents?.queryItems = queryItems
        }
        
        
        guard let url = urlComponents?.url else {return Fail(error: CustomError.generalError )
                     .eraseToAnyPublisher() }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse else {throw CustomError.generalError}
                guard 200...300 ~= response.statusCode else {throw CustomError.generalError}
                
                return data
            }
            .decode(type: responseModel.self, decoder: JSONDecoder())
            .mapError { error  in
                return error as? CustomError ?? .generalError
            }
            .eraseToAnyPublisher()
        
    }
    
    
    class func downloadImage(fromUrl url: URL) -> AnyPublisher<UIImage, CustomError> {
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let response = response as? HTTPURLResponse else {throw CustomError.generalError}
                guard 200...300 ~= response.statusCode else {throw CustomError.generalError}
                
                if let image = UIImage(data: data) {
                    return image
                } else {
                    throw CustomError.generalError
                }
            }
            .mapError { error  in
                return error as? CustomError ?? .generalError
            }
            .eraseToAnyPublisher()
        
    }
}
