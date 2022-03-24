
import UIKit
import Foundation

class JoinSessionController: UIViewController {
    
    lazy var sessionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var nameTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return lbl
    }()
    
    lazy var nameField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter Your Name")
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
        let field = CustomTextField(placeholder: "Enter Your Pass Code")
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
    
    lazy var joinSessionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join A Session", for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor.homeColour
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
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
        
        let controller = EstimateController()
        navigationController?.pushViewController(controller, animated: true)
        
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