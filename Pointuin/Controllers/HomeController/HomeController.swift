
import UIKit
import Firebase

class HomeController: UIViewController {
    
    private let inSessionState = SprintProgress.indev
    
    let teamDetailButton: JoinTeamView = {
        let btn = JoinTeamView()
        btn.addTarget(self, action: #selector(teamDetailsView), for: .touchUpInside)
        return btn
    }()
    
    
    let joinSessionButton: JoinButton = {
        let btn = JoinButton()
        btn.setTitle("Join", for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        btn.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    lazy var joinSprintBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join A Sprint Team", for: .normal)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.homeColour
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        btn.addTarget(self, action: #selector(joinSprint), for: .touchUpInside)
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
        self.navigationController?.navigationBar.barTintColor = UIColor.homeColour
        self.navigationItem.title = "My Teams"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.homeColour]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        self.setUpLayout()
        self.setupLogOutButton()
        self.setUpViewCase()
    }
    
    fileprivate func setUpViewCase() {
        self.joinSprintBtn.isHidden = true
        self.homeImage.isHidden = true
        
        switch inSessionState {
        case .noTeam:
            self.teamDetailButton.isHidden = true
            self.joinSprintBtn.isHidden = false
            self.homeImage.isHidden = false
        case .dev:
            self.joinSprintBtn.isHidden = true
        case .planning:
            self.joinSprintBtn.isHidden = false
        }
    }
    
    @objc private func joinSprint() {}
    
    @objc private func joinSession() {
        
    }
    
    @objc private func teamDetailsView() {
        
    }
    
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal).withTintColor(UIColor.homeColour), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    fileprivate func setUpLayout() {
        
        self.view.addSubview(self.homeImage)
        self.view.addSubview(self.joinSprintBtn)
        self.view.addSubview(self.teamDetailButton)
        self.teamDetailButton.addSubview(self.joinSessionButton)
        
        self.homeImage.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: 300, height: 300))
        self.homeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.homeImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.joinSprintBtn.anchor(top: self.homeImage.bottomAnchor, leading: self.homeImage.leadingAnchor, trailing: self.homeImage.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 50), padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        self.joinSprintBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.joinSessionButton.anchor(top: nil, leading: nil, trailing: joinSessionButton.superview?.trailingAnchor, bottom: nil, size: CGSize(width: 80, height: 40), padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        self.joinSessionButton.centerYAnchor.constraint(equalTo: joinSessionButton.superview!.centerYAnchor).isActive = true
        self.teamDetailButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 90), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        
    }
    
    @objc func handleLogOut() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .overFullScreen
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
