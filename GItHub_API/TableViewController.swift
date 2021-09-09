//
//  TableViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private func parseUsers(data: Data) {
        let decoder = JSONDecoder()
            
        guard
            let users = try! decoder.decode(Users?.self, from: data)
        else {
            print("Parse Error")
            return
        }
            
//        let countOfUsers = users.count
            
        for user in users.users {
            self.users[user.username] = user.image
//            listOfUsers.append(user.username)
        }
            
//        self.count = countOfUsers
//        self.users = listOfUsers
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    private func requestUsers(username: String) {
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
                return
            }
                
            self.parseUsers(data: data)
        }
        dataTask.resume()
    }

//    var count = 0
    private var users: [String:String] = [:]
    private let searchController = UISearchController()
//    private var searchTimer: Timer?
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
    }
    
    // MARK: - Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        self.requestUsers(username: text)
        self.tableView.reloadData()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.users.removeAll()
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.users.removeAll()
        self.tableView.reloadData()
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
//            self.requestUsers(username: text)
//        })
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

//        cell.imageView?.image = UIImage()
        cell.textLabel?.text = Array(self.users.keys)[indexPath.row]
        return cell
    }
    
        // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = (username: Array(self.users.keys)[indexPath.row],
                     imagePath: Array(self.users.values)[indexPath.row])
        
        if let viewController = storyboard?.instantiateViewController(identifier: "UserDetail") as? UserDetailViewController {
            viewController.username = user.username
            viewController.imagePath = user.imagePath

            navigationController?.pushViewController(viewController, animated: true)
        }
    }
        
    // MARK: - Hide keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
