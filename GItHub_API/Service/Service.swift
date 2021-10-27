//
//  Service.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 27/10/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import Foundation

class Service {
    
    static let shared = Service()
    
    // MARK: - Users
    
    func getUsers(username: String, completion: @escaping ([User], Error?) -> ()) {
        
        // Request Users
        
        let url = URL(string: "https://api.github.com/search/users?q=\(username)")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                switch (response as? HTTPURLResponse)!.statusCode {
                case 422: print("Request Error: User not found")
                default: print("Request Error: ", (response as? HTTPURLResponse)!.statusCode)
                }
                
                completion([], nil)
                return
            }
            
            // Parse Users
            
            guard
                let users = try! JSONDecoder().decode(Users?.self, from: data)
            else {
                print("Parse Error")
                completion([], nil)
                return
            }
            
            completion(users.users, nil)
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - Repositories
    
    func getRepositories(username: String, completion: @escaping ([Repository], Error?) -> ()) {
        
        // Request Repositories
        
        let url = URL(string: "https://api.github.com/users/\(username)/repos?sort=created")!
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                switch (response as? HTTPURLResponse)!.statusCode {
                case 422: print("Request Error: User not found")
                default: print("Request Error: ", (response as? HTTPURLResponse)!.statusCode)
                }
                
                completion([], nil)
                return
            }
            
            // Parse Repositories
            
            guard
                let repositories = try! JSONDecoder().decode([Repository]?.self, from: data)
            else {
                print("Parse Error")
                completion([], nil)
                return
            }
            
            completion(repositories, nil)
        }
        
        dataTask.resume()
    }
}
