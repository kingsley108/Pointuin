//
//  JoinTeamView.swift
//  Pointuin
//
//  Created by Kingsley Charles on 17/03/2022.
//

import UIKit

class CustomButton: UIButton {
    
     init(frame: CGRect, buttonText: String) {
        super.init(frame: frame)
        self.setupView()
        self.setTitle(buttonText, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    fileprivate func setupView() {
        self.backgroundColor = UIColor.systemGreen
        self.layer.cornerRadius = 4
        self.isHidden = false
        self.setTitle("Join Here", for: .normal)
        self.backgroundColor = UIColor.homeColour
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        self.titleLabel?.textAlignment = .center
    }
}

class HighlightedSessionButton: UIButton {
    
    var teamName: String? {
        
        didSet {
            self.buttonLabel.text = self.teamName
        }
    }
    
    var buttonOptions: SessionOptions = SessionOptions.indev {
        didSet {
            self.setupParameters()
        }
    }
    
    
    private var buttonLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.homeColour
        lbl.font = UIFont.systemFont(ofSize: 22)
        return lbl
    }()
    
    private var progressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "In development"
        lbl.textColor = UIColor.homeColour
        lbl.font = UIFont.systemFont(ofSize: 14)
        return lbl
    }()
    
    private var buttonIcon: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        addSubview(self.buttonLabel)
        addSubview(self.progressLabel)
        addSubview(self.buttonIcon)
        
        backgroundColor = UIColor.alternativeHomeColour
        self.setupView()
        self.setupParameters()
    }
    
    fileprivate func setupView() {
        
        self.buttonLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        self.buttonIcon.anchor(top: centerYAnchor, leading: buttonLabel.leadingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.progressLabel.anchor(top: nil, leading: buttonIcon.trailingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0))
        self.progressLabel.centerYAnchor.constraint(equalTo: buttonIcon.centerYAnchor).isActive = true
        
    }
    
    fileprivate func setupParameters() {
        
        switch buttonOptions {
        case .dev(let img):
            buttonIcon.image = img
        case .planningStart(let img):
            buttonIcon.image = img
        case .noTeamSession:
            return
        }
        
        
        
    }
    
    
    
    
    
}
