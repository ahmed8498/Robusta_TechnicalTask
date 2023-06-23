//
//  Repository.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import Foundation

struct Repository: Codable {
    
    var id: Int?
    var name: String?
    var fullName: String?
    var owner: RepositoryOwner?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
    }
}
