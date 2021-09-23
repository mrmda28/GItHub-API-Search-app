//
//  UserDetailViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Get Repositories
    
    private func parseRepositories(data: Data) {
        let decoder = JSONDecoder()
                
        guard
            let repositories = try! decoder.decode([Repository]?.self, from: data)
        else {
            print("Parse Error")
            return
        }
        
        for repository in repositories {
            self.repositories.append(repository.name)
        }

        DispatchQueue.main.async {
            self.repositoriesTableView.reloadData()
        }
    }
    
    private func requestRepositories(username: String) {
        let url = URL(string:
            "https://api.github.com/users/\(username)/repos?sort=created")!
            
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
                return
            }
            self.parseRepositories(data: data)
        }
        dataTask.resume()
    }
    
    // MARK: - Get Icon
    
    private func requestIcon(path: String) {
            let url = URL(string: path)!
            
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    error == nil,
                    (response as? HTTPURLResponse)?.statusCode == 200,
                    let data = data
                else {
                    DispatchQueue.main.async {
                        let image = UIImage(named: "default")
                        self.userImage.image = image
                                
                        print("Error getting the image")
                    }
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.userImage.image = image
                }
            }
            dataTask.resume()
        }
    
    // MARK: - Variables
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var repositoriesLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var username: String = ""
    var imagePath: String = ""
    
    private var repositories = [String]()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.username
        
        self.userImage.image = UIImage()
        self.userImage.backgroundColor = .white
        self.userImage.layer.cornerRadius = 20
        
        self.userImage.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.userImage.layer.borderWidth = 2
        
        self.requestIcon(path: imagePath)
        
        self.repositoriesTableView.dataSource = self
        self.repositoriesTableView.delegate = self
        self.repositoriesTableView.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.repositoriesTableView.layer.borderWidth = 3
        self.repositoriesTableView.layer.cornerRadius = 20
        
        self.requestRepositories(username: username)
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath)
        cell.textLabel?.text = self.repositories[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.selectionStyle = .none
        
        return cell
    }
}
