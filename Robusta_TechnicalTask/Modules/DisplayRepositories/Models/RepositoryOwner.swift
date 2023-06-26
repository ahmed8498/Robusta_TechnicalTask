//
//  RepositoryOwner.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 23/06/2023.
//

import UIKit

struct RepositoryOwner: Codable {
    var id: Int?
    var name: String?
    var imageURL: String?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case imageURL = "avatar_url"
    }
    
}
