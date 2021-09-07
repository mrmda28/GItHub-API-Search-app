//
//  TableViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    private func parseUsers(data: Data) {
        let decoder = JSONDecoder()
            
        guard
            let users = try! decoder.decode(Users?.self, from: data)
        else {
            print("Parse Error")
            return
        }
            
//        let countOfUsers = users.count
            
        var listOfUsers = [String]()
            
        for user in users.users {
            listOfUsers.append(user.username)
        }
            
//        self.count = countOfUsers
        self.users = listOfUsers
            
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
                print("Request Error")
                return
            }
                
            self.parseUsers(data: data)
        }
        dataTask.resume()
    }

//    var count = 0
    var users = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestUsers(username: "mrmda28")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)

//        cell.imageView?.image = UIImage()
        cell.textLabel?.text = Array(self.users)[indexPath.row]
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
