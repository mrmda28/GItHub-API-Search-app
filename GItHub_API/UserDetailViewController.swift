//
//  UserDetailViewController.swift
//  GItHub_API
//
//  Created by Dmitriy Maslennikov on 07/09/2021.
//  Copyright © 2021 mrmda28. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var username: String = ""
    var imagePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.userImage.image = UIImage()
//        self.userImage.layer.cornerRadius = 20
        
        self.usernameLabel.text = self.username
    }
}
