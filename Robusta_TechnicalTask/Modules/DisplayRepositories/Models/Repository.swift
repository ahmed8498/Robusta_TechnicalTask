//
//  Repository.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation

class Repository: Codable {
    
    var id: Int?
    var name: String?
    var fullName: String?
    var owner: RepositoryOwner?
    var description: String?
    var url: String?
    var moreInfo: RepositoryMoreInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
        case url
    }
}

struct RepositoryMoreInfo: Codable {
    var createdAt: String?
    var lastUpdatedAt: String?
    var forksCount: Int?
    var openIssuesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case lastUpdatedAt = "updated_at"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}
