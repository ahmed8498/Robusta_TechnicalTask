//
//  NetworkRequest.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation

enum NetworkMethod: String {
    case get = "GET"
       case post = "POST"
       case put = "PUT"
       case delete = "DELETE"
}

protocol NetworkRequest {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: NetworkMethod { get }
    
    var body: Data? { get }
    
    var queryParameters: [String: String]? { get }
    
    var headers: [String: String]? { get }
}
