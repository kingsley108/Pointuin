//
//  MainTabController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 20/02/2022.

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var index = 0
    var titles = ["Home", "Leaderboard", "Profile"]
    
    
    override func viewDidLoad() {
        self.setUpVc()
        if Auth.auth().currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
    }
    
    func setUpVc ()
    {
        //Home Profile
        let homeVc = HomeController()
        let homeNav = templateController(selectedimage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), vc: homeVc)
        homeVc.navigationController?.navigationBar.isHidden = false
        
        //Search Navigator
        let dashboardVc = LeaderBoardController()
        let dashboardNav = templateController(selectedimage: #imageLiteral(resourceName: "list"), unselectedImage: #imageLiteral(resourceName: "list"), vc: dashboardVc)
        
        //UserProfile Navigator
        let profileVc = UserProfileController(userModel: nil) //TeamProfileController()
        let userNav = templateController(selectedimage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), vc: profileVc)
        
        viewControllers = [homeNav,dashboardNav,userNav]
        tabBar.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tabBar.barTintColor = .white
        
        //Iterate through tabBar items
        for item in self.tabBar.items! as [UITabBarItem]
        {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
            item.title = titles[index]
            index += 1
        }
        
    }
    
    func templateController(selectedimage: UIImage , unselectedImage: UIImage, vc : UIViewController? = UIViewController ()) -> UINavigationController
    {
        let vc = vc
        let templateNav = UINavigationController(rootViewController: vc!)
        templateNav.navigationBar.isHidden = false
        templateNav.tabBarItem.selectedImage = selectedimage
        templateNav.tabBarItem.image = unselectedImage
        return templateNav
        
        
    }
    
    
    
    
}

