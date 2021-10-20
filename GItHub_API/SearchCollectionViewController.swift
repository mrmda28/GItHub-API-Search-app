//
//  SearchCollectionViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 14/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UserCell"

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Get Users
     
    private func parseUsers(data: Data) {
        let decoder = JSONDecoder()
            
        guard
            let users = try! decoder.decode(Users?.self, from: data)
        else {
            print("Parse Error")
            return
        }
            
        for user in users.users {
            self.users[user.username] = user.image
        }
            
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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

    // MARK: - Variables
    
    private var users: [String:String] = [:]
    private let searchController = UISearchController()

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        setupSearchBar()
    }
    
    // MARK: - Setup SearchBar
    
    private func setupSearchBar() {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
    }

    // MARK: - CollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchUserCollectionViewCell
    
        cell.userImage.image = UIImage(named: "default")
        cell.usernameLabel.text = Array(self.users.keys)[indexPath.row]

        cell.userImage.backgroundColor = .white
        cell.userImage.layer.cornerRadius = 20
        
        cell.layer.borderColor = UIColor.secondarySystemFill.cgColor
        cell.layer.borderWidth = 3
        
        cell.layer.cornerRadius = 20
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = (username: Array(self.users.keys)[indexPath.row],
                     imagePath: Array(self.users.values)[indexPath.row])
        
        if let viewController = storyboard?.instantiateViewController(identifier: "UserDetail") as? UserDetailViewController {
            viewController.username = user.username
            viewController.imagePath = user.imagePath

            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = self.collectionView.bounds.width
        return CGSize(width: (collectionWidth-50)/2, height: 186.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: - Hide keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Search

extension SearchCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text else { return }
        self.requestUsers(username: text)
        self.collectionView.reloadData()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.users.removeAll()
        self.collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.users.removeAll()
        self.collectionView.reloadData()
    }
}
