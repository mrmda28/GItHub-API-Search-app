//
//  UserDetailViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    private func requestIcon(path: String) {
            let url = URL(string: path)!
            
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    error == nil,
                    (response as? HTTPURLResponse)?.statusCode == 200,
                    let data = data
                else {
                    DispatchQueue.main.async {
//                        self.iconActivityIndicator.stopAnimating()
                                
                        let image = UIImage(named: "default")
                        self.userImage.image = image
                                
                        print("Error getting the image")
                    }
                    return
                }
                DispatchQueue.main.async {
//                    self.iconActivityIndicator.stopAnimating()

                    let image = UIImage(data: data)
                    self.userImage.image = image
                }
            }
            dataTask.resume()
        }
    
    
    @IBOutlet weak var userImage: UIImageView!
//    @IBOutlet weak var usernameLabel: UILabel!
    
    var username: String = ""
    var imagePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.username
        
        self.userImage.image = UIImage()
        self.userImage.backgroundColor = .white
        self.userImage.layer.cornerRadius = 20
        
        self.userImage.layer.borderColor = UIColor.secondarySystemFill.cgColor
        self.userImage.layer.borderWidth = 2
        
        self.requestIcon(path: imagePath)
    }
}
