
import Foundation
import UIKit
import JGProgressHUD
import FirebaseFirestore

class CreateSessionController: UIViewController {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    lazy var pageTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create A New Team"
        lbl.font = UIFont.systemFont(ofSize: 40, weight: .light)
        lbl.textColor = .homeColour
        lbl.contentMode = .bottomLeft
        return lbl
    }()
    
    lazy var teamField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter Team Name")
        return field
    }()
    
    lazy var passcodeField: CustomTextField = {
        let field = CustomTextField(placeholder: "Enter Passcode For Room")
        return field
    }()
    
    lazy var saveSessionBtn: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Create")
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(saveSession), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.text = "Team name*"
        return lbl
    }()
    
    let contentStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        title = ""
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        self.view.addSubview(self.contentStackView)
        self.contentStackView.addArrangedSubview(self.pageTitle)
        self.contentStackView.addArrangedSubview(self.btnLabel)
        self.contentStackView.setCustomSpacing(15, after: self.pageTitle)
        self.contentStackView.addArrangedSubview(self.teamField)
        self.contentStackView.addArrangedSubview(self.passcodeField)
        self.contentStackView.addArrangedSubview(self.saveSessionBtn)
        self.anchor()
    }
    
    fileprivate func anchor() {
        let height = SafeAreaFrame.height / 3.5 //4
        let padding = (SafeAreaFrame.width) * 0.75
        
        self.contentStackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height:height), padding: UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 20))
        
        self.saveSessionBtn.anchor(top: nil, leading: contentStackView.leadingAnchor, trailing: self.contentStackView.trailingAnchor, bottom: self.contentStackView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding))
    }
    
    @objc fileprivate func saveSession() {
        let sessionID = self.generateUuidString()
        let data: [String: Any] = ["team": self.teamField.text ,"passcode": self.passcodeField.text, "sessionStatus": "inactive" ]
        Firestore.db.saveDocument(collection: "sessions", document: sessionID, data: data)
        
        self.hud.show(in: self.view)
        self.hud.detailTextLabel.text = "Your session number is \(sessionID) please give this to your team."
        self.hud.textLabel.text = "CREATING SESSION"
        
        self.hud.dismiss(afterDelay: 4, animated: true)
    }
    
    func generateUuidString() -> String {
        let text = UUID().uuidString
        let index = text.index(text.startIndex, offsetBy: 8)
        let small = text[text.startIndex..<index]
        return String(small)
    }
    
    
    
    
}
