//
//  ConfirmEstimationController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 22/03/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class ConfirmEstimationController: UIViewController {
    
    fileprivate var point: String
    fileprivate var planningTitle: String
    fileprivate let width = SafeAreaFrame.width * 0.75
    fileprivate let height = SafeAreaFrame.height * 0.35
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    let cardStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        return view
    }()
    
    let confirmationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var confirmPointuinTitle: UILabel = {
        let label = UILabel()
        label.text = "Is this your estimation?"
        label.textColor = .homeColour
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        return label
    }()
    
    lazy var viewCard: PointerView = {
        let view = PointerView()
        view.userPoint = self.point
        return view
    }()
    
    lazy var confirmYesView: CustomButton = {
        let button = CustomButton(frame: .zero, buttonText: "Yes")
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(self.confirmEstimation), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmNoView: CustomButton = {
        let button = CustomButton(frame: .zero, buttonText: "No")
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(self.rejectEstimation), for: .touchUpInside)
        return button
    }()
    
    init(point: String, title: String) {
        self.point = point
        self.planningTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.planningTitle
        self.view.addSubview(self.contentStackView)
        self.view.addSubview(self.confirmationStackView)
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = false
        self.setUpViews()
    }
    
    @objc fileprivate func confirmEstimation() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let firestore = Firestore.firestore()
        let data = ["voted": "true", "pointSelected": self.point]
        
        firestore.updateUserData(uid: uid, dictionary: data) { err in
            
            if let err = err {
                print(err)
                return
            }
            
            firestore.getUserProfileDetails { [unowned self] err, profileImageUrl, sessionID  in
                
                if let err = err {
                    print(err)
                    return
                }
                
                guard let profileImageUrl = profileImageUrl else {return}
                guard let sessionIdentifier = sessionID else {return}
                        
                let activeSession =  ["sessionStatus": "active"]
                Firestore.db.updateDocument(collection: "sessions", document: "\(sessionIdentifier)", data: activeSession)
                
                let controller = StoryStatsViewController(userPoint: self.point, profileUrl: profileImageUrl)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            
        }
    }
    
    
    fileprivate func setUpViews() {
        
        let spacing = width * 0.15
        let buttonSpacing = width * 0.4
        
        self.contentStackView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width, height: height))
        self.contentStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.contentStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.contentStackView.addArrangedSubview(self.confirmPointuinTitle)
        self.contentStackView.spacing = spacing
        self.contentStackView.addArrangedSubview(self.cardStackView)
        self.cardStackView.addArrangedSubview(UIView())
        self.cardStackView.addArrangedSubview(self.viewCard)
        self.cardStackView.addArrangedSubview(UIView())
        
        self.contentStackView.addArrangedSubview(self.confirmationStackView)
        self.confirmationStackView.addArrangedSubview(self.confirmYesView)
        self.confirmationStackView.spacing = buttonSpacing
        self.confirmationStackView.addArrangedSubview(self.confirmNoView)
    }
    
    @objc fileprivate func rejectEstimation() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
