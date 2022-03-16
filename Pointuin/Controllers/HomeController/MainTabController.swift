//
//  MainTabController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 20/02/2022.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var index : Int?
    
    override func viewDidLoad() {
        self.delegate = self
//        if Auth.auth().currentUser == nil {
//            //show if not logged in
//            DispatchQueue.main.async {
//                let loginController = LoginViewController()
//                let navController = UINavigationController(rootViewController: loginController)
//                navController.modalPresentationStyle = .fullScreen
//                self.present(navController, animated: true, completion: nil)
//            }
//            return
//        }

        setUpVc()
        navigationController?.navigationBar.isHidden = true

    }
    
    func setUpVc ()
    {
        //Home Profile
        let homeVc = HomeController()
        let homeNav = templateController(selectedimage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), vc: homeVc)
        
        //Search Navigator
        let dashboardVc = DashboardController()
        let dashboardNav = templateController(selectedimage: #imageLiteral(resourceName: "list"), unselectedImage: #imageLiteral(resourceName: "list"), vc: dashboardVc)
        
        //UserProfile Navigator
        let profileVc = UserProfileController()
        let userNav = templateController(selectedimage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), vc: profileVc)
        
        viewControllers = [homeNav,dashboardNav,userNav]
        tabBar.tintColor = #colorLiteral(red: 0.2539359629, green: 0.3838947415, blue: 0.9965317845, alpha: 1)
        tabBar.barTintColor = .white
        
        //Iterate through tabBar items
        for item in self.tabBar.items! as [UITabBarItem]
        {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        
    }
    
    func templateController(selectedimage: UIImage , unselectedImage: UIImage, vc : UIViewController? = UIViewController ()) -> UINavigationController
    {
        let vc = vc
        let templateNav = UINavigationController(rootViewController: vc!)
        templateNav.navigationBar.isHidden = true
        templateNav.tabBarItem.selectedImage = selectedimage
        templateNav.tabBarItem.image = unselectedImage
        return templateNav
        
        
    }
    
    
    
    
}

