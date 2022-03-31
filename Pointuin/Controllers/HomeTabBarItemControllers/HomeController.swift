
import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    private var inSessionState = SessionOptions.noTeamSession
    private var memberType = MemberType.dev
    private var hasEstimated = false
    
    let infoDetailView: InfoDetailView = {
        let view = InfoDetailView()
        view.isHidden = false
        return view
    }()
    
    let teamDetailButton: HighlightedSessionButton = {
        let btn = HighlightedSessionButton()
        btn.addTarget(self, action: #selector(teamDetailsView), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    let homeDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.isHidden = false
        return stackView
    }()
    
    
    let joinActiveSessionBtn: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Join")
        btn.backgroundColor = UIColor.orange
        btn.isHidden = false
        btn.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        return btn
    }()
    
    lazy var joinSprintBtn: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Join A Sprint Team")
        btn.addTarget(self, action: #selector(self.joinSprint), for: .touchUpInside)
        btn.isHidden = false
        return btn
    }()
    
    lazy var homeImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image =  #imageLiteral(resourceName: "lonely")
        return imgView
        
    }()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigatonItemAttributes()
        self.hud.show(in: self.view)
        self.fetchCurrentUser()
        self.setUpLayout()
        self.setupLogOutButton()
        self.setUpViewCase()
    }
    
    fileprivate func setNavigatonItemAttributes() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.homeColour, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .regular)]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    
    fileprivate var user: User? {
        didSet {
            
            guard let user = user else {return}
            self.navigationItem.title = "\(user.team) Sprint Plan"
            
            self.memberType = MemberType(rawValue: user.acessLevel) ?? .none
            self.inSessionState = SessionOptions(state: SessionState(sessionSate: user.sessionStatus))
            self.teamDetailButton.buttonOptions = self.inSessionState
            self.hasEstimated = user.voted.bool
            
            
            if self.memberType == .admin {
                joinSprintBtn.setTitle("Create A Sprint Team", for: .normal)
            }
            
            print(self.memberType)
            print(self.inSessionState)
            self.teamDetailButton.teamName = user.team
            self.setUpViewCase()
        }
    }
    
    fileprivate func fetchCurrentUser() {

        guard let uId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().getUserUpdates(uid: uId) { (user, err) in
            
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            
            self.user = user
            if let isSessionOn = self.user?.adminSessionOn, isSessionOn, self.memberType == .admin {
                self.joinSprintBtn.setTitle("Continue Sprint Planning", for: .normal)
            }
            self.hud.dismiss(afterDelay: 0.5, animated: true)
        }
    }
    
    fileprivate func setUpViewCase() {

        self.homeDetailStackView.isHidden = true
        
        switch inSessionState {
        case .noTeamSession:
            self.teamDetailButton.isHidden = true
            self.joinSprintBtn.isHidden = false
            self.homeDetailStackView.isHidden = false
        case .dev:
            self.teamDetailButton.isHidden = false
            self.joinActiveSessionBtn.isHidden = true
        case .planningStart:
            self.teamDetailButton.isHidden = false
            self.joinActiveSessionBtn.isHidden = false
        }
    }
    
    @objc private func joinSprint() {
        
    
        if self.memberType == .admin {
            if let isSessionOn = self.user?.adminSessionOn, isSessionOn {
                guard let team = self.user?.team else {return}
                guard let sessionID = self.user?.sessionID else {return}
                
                let controller = AdminControlsViewController(titleText: team, sessionID: sessionID, previousStory: self.user?.storySummary)
                navigationController?.pushViewController(controller, animated: true)
                
            } else {
                let controller = CreateSessionController()
                navigationController?.pushViewController(controller, animated: true)
            }
            
        } else {
            let controller = JoinSessionController()
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc private func joinSession() {
            
            let userSelectedVote = self.user?.pointSelected != nil
            
            if self.hasEstimated && userSelectedVote {
                guard let userSelectedVote = self.user?.pointSelected else {return}
                guard let user = self.user else {return}
                let controller = StoryStatsViewController(userPoint: userSelectedVote, profileUrl: user.profileImageUrl)
                self.navigationController?.pushViewController(controller, animated: true)
                return
            } else {
                let estimateController = EstimateController()
                self.navigationController?.pushViewController(estimateController, animated: true)
            }
    }
    
    @objc private func teamDetailsView() {
        let controller = TeamDetailsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal).withTintColor(UIColor.white), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    fileprivate func setUpLayout() {
        
        self.view.addSubview(self.teamDetailButton)
        self.teamDetailButton.addSubview(self.joinActiveSessionBtn)
        
        self.teamDetailButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 90), padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        self.joinActiveSessionBtn.anchor(top: nil, leading: nil, trailing: joinActiveSessionBtn.superview?.trailingAnchor, bottom: nil, size: CGSize(width: 80, height: 40), padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        self.joinActiveSessionBtn.centerYAnchor.constraint(equalTo: joinActiveSessionBtn.superview!.centerYAnchor).isActive = true
        self.setupStackView()
        
    }
    
    fileprivate func setupStackView() {

        self.view.addSubview(self.homeDetailStackView)
        self.homeDetailStackView.addArrangedSubview(self.homeImage)
        self.homeDetailStackView.addArrangedSubview(self.infoDetailView)
        homeDetailStackView.setCustomSpacing(20, after: self.infoDetailView)
        self.homeDetailStackView.addArrangedSubview(self.joinSprintBtn)
        let height = UIScreen.main.bounds.height / 2
        let width = UIScreen.main.bounds.width / 1.5
        let imageWidth = UIScreen.main.bounds.width / 1.5
        
        self.homeDetailStackView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width, height: height))
        self.homeDetailStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.homeDetailStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
