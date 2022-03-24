
import UIKit
import Firebase

class HomeController: UIViewController {
    
    private let inSessionState = SprintProgress.noTeam
    
    let infoDetailView: InfoDetailView = {
        let view = InfoDetailView()
        return view
    }()
    
    let teamDetailButton: HighlightedButton = {
        let btn = HighlightedButton()
        btn.addTarget(self, action: #selector(teamDetailsView), for: .touchUpInside)
        return btn
    }()
    
    let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    
    let joinActiveSessionBtn: JoinButton = {
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
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor.homeColour
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        btn.addTarget(self, action: #selector(self.joinSprint), for: .touchUpInside)
        return btn
    }()
    
    lazy var homeImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image =  #imageLiteral(resourceName: "lonely")
        return imgView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setUpLayout()
        self.setupLogOutButton()
        self.setUpViewCase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Teams"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.homeColour, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .regular)]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    fileprivate func setUpViewCase() {

        switch inSessionState {
        case .noTeam:
            self.teamDetailButton.isHidden = true
            self.joinSprintBtn.isHidden = false
            self.homeImage.isHidden = false
        case .dev:
            self.joinSprintBtn.isHidden = true
            self.homeImage.isHidden = true
            self.joinActiveSessionBtn.isHidden = true
        case .planning:
            self.joinActiveSessionBtn.isHidden = false
            self.homeImage.isHidden = true
            self.joinSprintBtn.isHidden = true
        }
    }
    
    @objc private func joinSprint() {
        let controller = JoinSessionController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func joinSession() {
        let estimateController = EstimateController()
        navigationController?.pushViewController(estimateController, animated: true)
    }
    
    @objc private func teamDetailsView() {
        let controller = TeamDetailsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal).withTintColor(UIColor.homeColour), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    fileprivate func setUpLayout() {
        
        self.view.addSubview(self.teamDetailButton)
        self.teamDetailButton.addSubview(self.joinActiveSessionBtn)
        
        self.teamDetailButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 90), padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        self.joinActiveSessionBtn.anchor(top: nil, leading: nil, trailing: joinActiveSessionBtn.superview?.trailingAnchor, bottom: nil, size: CGSize(width: 80, height: 40), padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        self.joinActiveSessionBtn.centerYAnchor.constraint(equalTo: joinActiveSessionBtn.superview!.centerYAnchor).isActive = true
        self.setupStackView()
        
    }
    
    fileprivate func setupStackView() {

        self.view.addSubview(self.detailStackView)
        self.detailStackView.addArrangedSubview(self.homeImage)
        self.detailStackView.addArrangedSubview(self.infoDetailView)
        detailStackView.setCustomSpacing(20, after: self.infoDetailView)
        self.detailStackView.addArrangedSubview(self.joinSprintBtn)
        let height = UIScreen.main.bounds.height / 2
        let width = UIScreen.main.bounds.width / 1.5
        let imageWidth = UIScreen.main.bounds.width / 1.5
        
        self.detailStackView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width, height: height))
        self.detailStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.detailStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.homeImage.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: imageWidth, height: imageWidth))
        self.infoDetailView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width, height: width/2.5))
        self.joinSprintBtn.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width - 80, height: 0))

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
