//
//  HomeViewController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 20/02/2022.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    lazy var teamCreationButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join A Sprint Team", for: .normal)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        btn.addTarget(self, action: #selector(createTeam), for: .touchUpInside)
        return btn
    }()
    
    lazy var homeImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image =  #imageLiteral(resourceName: "lonely")
        return imgView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        self.setUpLayout()
        self.setupLogOutButton()
        
    }
    
    @objc private func createTeam() {
        print("Team created")
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    fileprivate func setUpLayout() {
        self.view.addSubview(self.homeImage)
        self.view.addSubview(self.teamCreationButton)
        self.homeImage.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: 300, height: 300))
        self.homeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.homeImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.teamCreationButton.anchor(top: self.homeImage.bottomAnchor, leading: self.homeImage.leadingAnchor, trailing: self.homeImage.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 50), padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        self.teamCreationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                //what happens? we need to present some kind of login controller
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
