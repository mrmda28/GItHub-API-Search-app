//
//  UserModel.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import Foundation

struct User: Codable {
//    let id: Int
    let username: String
//    let url: URL
    
    enum CodingKeys: String, CodingKey {
//        case id
        case username = "login"
//        case url = "html_url"
    }
}

struct Users: Codable {
//    let count: Int
//    let incompleteResults: Bool
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
//        case count = "total_count"
//        case incompleteResults = "incomplete_results"
        case users = "items"
    }
}
