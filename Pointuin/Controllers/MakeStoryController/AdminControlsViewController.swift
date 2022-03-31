//
//  ControlGroupControllersView.swift

import UIKit
import JGProgressHUD
import FirebaseFirestore
import FirebaseAuth

class AdminControlsViewController: UIViewController, StoryEstimationDelegate{
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    fileprivate var sessionID: String
    fileprivate var team: String
    fileprivate var previousStory: String?
    
    init(titleText: String, sessionID: String, previousStory: String? = nil) {
        
        self.sessionID = sessionID
        self.team = titleText
        self.previousStory = previousStory
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = titleText
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dateString: String = {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }()
    
    lazy var pointuinTitle: UILabel = {
        let label = UILabel()
        label.text = "Planning (\(dateString))"
        label.textColor = .homeColour
        label.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .homeColour
        imageView.image = UIImage(systemName: "desktopcomputer")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    lazy var timeAgoDisplayLabel: UILabel = {
        let label = UILabel()
//        let timeAgoDisplay = creationDate.timeAgoDisplay()
        label.text = "Started 1 minute ago"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    lazy var storyEstimationView: StoryEstimationView = {
        let view = StoryEstimationView(frame: .zero, sessionID: sessionID)
        view.enableStopControls = false
        view.userCanEstimate = false
        view.enableAddStory = true
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupView()
        self.checkPreviousStory()
    }
    
    fileprivate func checkPreviousStory() {
        
        guard let story = self.previousStory else {return}
        if !story.isEmpty
        {
            self.storyEstimationView.enableStopControls = true
            self.storyEstimationView.storyTextBox.text = story
            self.storyEstimationView.userCanEstimate = false
            self.storyEstimationView.enableAddStory = false
        }
    }
    
    fileprivate func setupView() {
        view.addSubview(self.pointuinTitle)
        view.addSubview(self.iconImageView)
        view.addSubview(self.timeAgoDisplayLabel)
        view.addSubview(self.storyEstimationView)
        self.addLayoutConstraints()
    }
    
    fileprivate func addLayoutConstraints() {
        
        
        let labelSize = self.pointuinTitle.getIntrinsicHeight()
        let timeAgoLabel = self.timeAgoDisplayLabel.getIntrinsicHeight()
        let useView = self.pointuinTitle
        let width = SafeAreaFrame.width
        let height = SafeAreaFrame.height
        
        self.pointuinTitle.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil, size: labelSize ,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        self.iconImageView.anchor(top: useView.bottomAnchor, leading: useView.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: 40, height: 40), padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        self.timeAgoDisplayLabel.anchor(top: nil, leading: self.iconImageView.trailingAnchor, trailing: nil, bottom: nil, size: timeAgoLabel, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        self.timeAgoDisplayLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor).isActive = true
        
        
        self.storyEstimationView.anchor(top: self.iconImageView.bottomAnchor, leading: useView.leadingAnchor, trailing: useView.trailingAnchor, bottom: nil, size: CGSize(width: width - 20, height: height * 0.5), padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
    }
    
    func createStory(storySummary: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let sessionData =  ["storySummary": storySummary, "team": self.team]
        
        Firestore.db.updateDocument(collection: "users", document: "\(uid)", data: sessionData)
        Firestore.db.updateDocument(collection: "sessions", document: "\(self.sessionID)", data: sessionData)
        
        self.hud.show(in: self.view)
        self.hud.textLabel.text = "CREATING A STORY 🎬🔰"
        self.hud.detailTextLabel.text = "Please click on the 'start session button' give this to start a session and begin your team estimatong journey"
        self.hud.dismiss(afterDelay: 4)
        self.storyEstimationView.userCanEstimate = true
    }
    
    func didStartSession() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let activeSession =  ["sessionStatus": "active", "hasVoted": "false"]
        Firestore.db.updateDocument(collection: "sessions", document: "\(self.sessionID)", data: activeSession)
        let userData: [String: String] = ["sessionOn": "true"]
        Firestore.db.updateDocument(collection: "users", document: "\(uid)", data: userData)
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "hasVoted") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "sessionStatus") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        
        self.navigationItem.hidesBackButton = true
        self.storyEstimationView.userCanEstimate = false
        self.storyEstimationView.enableStopControls = true
        self.storyEstimationView.enableAddStory = false
        
        self.hud.show(in: self.view)
        self.hud.textLabel.text = "SESSION NOW STARTED  🎬🔰"
        self.hud.detailTextLabel.text = "Your story can now not be edited by you. Your session number is \(sessionID) please give this to your team to join and give estimation for the current story."
        self.hud.dismiss(afterDelay: 4)
    }
    
    func endPlanningSession() {
        
        self.storyEstimationView.userCanEstimate = false
        self.storyEstimationView.enableAddStory = false
        self.storyEstimationView.enableStopControls = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userData: [String: String] = ["sessionOn": "false", "team": ""]
        let activeSession =  ["sessionStatus": "noSession", "hasVoted": "false", "team": ""]
        Firestore.db.updateDocument(collection: "sessions", document: "\(self.sessionID)", data: activeSession)
        Firestore.db.updateDocument(collection: "users", document: "\(uid)", data: userData)
        
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "hasVoted") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "sessionStatus") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "team") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        self.hud.textLabel.text = "SESSION NOW ENDED  🎬🔰"
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func restartPlanningSession() {
        
        self.storyEstimationView.userCanEstimate = false
        self.storyEstimationView.enableStopControls = false
        self.storyEstimationView.enableAddStory = true
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userData: [String: String] = ["sessionOn": "true"]
        let activeSession =  ["sessionStatus": "inactive", "hasVoted": "true"]
        Firestore.db.updateDocument(collection: "sessions", document: "\(self.sessionID)", data: activeSession)
        Firestore.db.updateDocument(collection: "users", document: "\(uid)", data: userData)
        self.hud.textLabel.text = "SESSION NOW RESTARTED, PLEASE ENTER A NEW STORY  🎬🔰"
        
        Firestore.db.updateSessionStatusForUsers(documentID: "\(self.sessionID)", updatedFieldName: "sessionStatus") { err in
            
            if let err = err {
                print("Failed to fetch card user:", err)
                return
            }
        }
        
    }
    
}
