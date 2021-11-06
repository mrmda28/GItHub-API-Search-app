//
//  NetworkManager.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 27/10/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // MARK: - Users
    
    func getUsers(username: String, completion: @escaping ([User], Error?) -> ()) {
        
        // Request Users
        
        guard let url = URL(string: "https://api.github.com/search/users?q=\(username)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                switch (response as? HTTPURLResponse)!.statusCode {
                case 422: print("Request Error: User not found")
                default: print("Request Error: \(username)", (response as? HTTPURLResponse)!.statusCode)
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
            
            DispatchQueue.main.async {
                completion(users.users, nil)
            }
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - Repositories
    
    func getRepositories(username: String, completion: @escaping ([Repository], Error?) -> ()) {
        
        // Request Repositories
        
        guard let url = URL(string: "https://api.github.com/users/\(username)/repos?sort=created") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                switch (response as? HTTPURLResponse)!.statusCode {
                case 422: print("Request Error: Repositories not found")
                default: print("Request Error: \(username)", (response as? HTTPURLResponse)!.statusCode)
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
            
            DispatchQueue.main.async {
                completion(repositories, nil)
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - User Image
    
    func getUserImage(url: String, completion: @escaping (UIImage) -> ()) {
        
        guard let imageURL = URL(string: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print("Image Request Error: \((response as? HTTPURLResponse)!.statusCode))")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        dataTask.resume()
    }
}
