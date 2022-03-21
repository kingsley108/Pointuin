//
//  JoinTeamView.swift
//  Pointuin
//
//  Created by Kingsley Charles on 17/03/2022.
//

import UIKit

class JoinButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    fileprivate func setupView() {
        backgroundColor = UIColor.systemGreen
        isHidden = false
        setTitle("Join Here", for: .normal)
    }
}

class HighlightedButton: UIButton {
    
    fileprivate var buttonParameters: SprintProgress
    
    private var buttonLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Pheonix"
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
        self.buttonParameters = SprintProgress.indev
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.buttonParameters = SprintProgress.indev
        super.init(coder: aDecoder)
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        addSubview(buttonLabel)
        addSubview(progressLabel)
        addSubview(buttonIcon)
        
        backgroundColor = UIColor.alternativeHomeColour
        self.setupView()
        self.setupParameters()
    }
    
    fileprivate func setupView() {
        
        buttonLabel.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        buttonIcon.anchor(top: centerYAnchor, leading: buttonLabel.leadingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        progressLabel.anchor(top: nil, leading: buttonIcon.trailingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0))
        progressLabel.centerYAnchor.constraint(equalTo: buttonIcon.centerYAnchor).isActive = true
        
    }
    
    fileprivate func setupParameters() {
        
        switch buttonParameters {
        case .dev(let img):
            buttonIcon.image = img
        case .planning(let img):
            buttonIcon.image = img
        case .noTeam:
            return
        }
        
        
        
    }
    
    
    
    
    
}
