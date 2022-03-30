
import UIKit
import Foundation
import JGProgressHUD
import FirebaseFirestore

class JoinSessionController: UIViewController {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Joining Session"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    lazy var sessionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var nameTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    
    lazy var nameField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter A Display Name")
        return field
    }()
    
    
    lazy var sessionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Session"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    
    
    lazy var sessionField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter Your Session ID")
        return field
    }()
    
    lazy var passcodeField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter The Pass Code")
        return field
    }()
    
    let sessionInformationLabel: InformationLabel = {
        let lbl = InformationLabel()
        lbl.text = """
        Enter session ID and 4 digit numeric passcode
        to join an exising session
        """
        return lbl
    }()
    
    let passcodeLabel: InformationLabel = {
        let lbl = InformationLabel()
        lbl.text = "Pass Code and Session ID are required field."
        lbl.textColor = .red
        return lbl
    }()
    
    
    let votingInformationLabel: InformationLabel = {
        let lbl = InformationLabel()
        lbl.text = """
        Toggle the switch below to only view the estimation and join as read-only.
        """
        return lbl
    }()
    
    lazy var votingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Voting Or Viewing?"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    
    let votingInformationView: VotingInformationView = {
        let vview = VotingInformationView()
        return vview
    }()
    
    lazy var joinSessionBtn: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Join A Session")
        btn.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Join Session"
        self.view.addSubview(self.sessionStackView)
        self.sessionStackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor , trailing: self.view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, padding: UIEdgeInsets(top: 20, left: 50, bottom: 0, right: 50))
        self.setupStackview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc fileprivate func joinSession() {
        
        guard let displayname = nameField.text else {return}
        guard let sessionID = sessionField.text else {return}
        guard let passCode = passcodeField.text else {return}
        
        self.hud.textLabel.text = "JOINING SESSION NOW 🎬💤"
        self.hud.detailTextLabel.text = "Please hold on While we join you in this session......"
        self.hud.show(in: self.view)
        
        let sessionIdentifier = String(sessionID.filter { !" \n\t\r".contains($0) })
        
        Firestore.db.checkSessionExists(displayName: displayname, sessionID: sessionIdentifier, passCode: passCode, completion: { [weak self] err in
            
            if let err = err {
                self?.showHUDWithError(error: err)
                return
            }
            
            self?.hud.dismiss()
            let controller = EstimateController()
            self?.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    fileprivate func showHUDWithError(error: Error) {
        self.hud.textLabel.text = "Session Not Joined, Try Again"
        self.hud.detailTextLabel.text = error.localizedDescription
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 4)
    }
    
    func setupStackview() {
        self.sessionStackView.addArrangedSubview(self.nameTitle)
        self.sessionStackView.addArrangedSubview(self.nameField)
        self.sessionStackView.addArrangedSubview(self.sessionLabel)
        self.sessionStackView.addArrangedSubview(self.sessionInformationLabel)
        self.sessionStackView.addArrangedSubview(self.sessionField)
        self.sessionStackView.addArrangedSubview(self.passcodeField)
        self.sessionStackView.addArrangedSubview(self.passcodeLabel)
        self.sessionStackView.addArrangedSubview(self.votingLabel)
        self.sessionStackView.addArrangedSubview(self.votingInformationLabel)
        self.sessionStackView.setCustomSpacing(10, after: self.votingInformationLabel)
        self.sessionStackView.addArrangedSubview(self.votingInformationView)
        self.sessionStackView.addArrangedSubview(self.joinSessionBtn)
        self.sessionStackView.addArrangedSubview(UIView())
    }
    
    
}
