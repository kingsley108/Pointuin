//
//  StoryEstimationView.swift
//  Pointuin
//
//  Created by Kingsley Charles on 28/03/2022.
//

import UIKit
import FirebaseFirestore

protocol StoryEstimationDelegate {
    
    func didStartSession()
    func createStory(storySummary: String)
    func endPlanningSession()
    func restartPlanningSession()
}

class StoryEstimationView: UIView {
    
    var delegate: StoryEstimationDelegate?
    
    init(frame: CGRect, sessionID: String) {
        super.init(frame: .zero)
        self.backgroundColor = .systemGray5
        self.setupViews()
    }
    
    var enableStopControls: Bool = false {
        
        didSet {
            
            let didEnable = enableStopControls
            let controlsAlpha: Double = didEnable ? 0.4 : 0
            
            self.startEstimatingButton.isEnabled = !didEnable
            self.startEstimatingButton.alpha = 1 - controlsAlpha
            self.restartSprintButton.isEnabled = didEnable
            self.restartSprintButton.alpha = 0.6 + controlsAlpha
            self.endPlanningButton.isEnabled = didEnable
            self.endPlanningButton.alpha = 0.6 + controlsAlpha
            self.storyTextBox.isUserInteractionEnabled = !didEnable
        }
    }
    
    required init?(coder: NSCoder, sessionID: String) {
        super.init(coder: coder)
        self.setupViews()
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var storyTextBox: CustomTextField = {
        let txtField = CustomTextField(placeholder: "Write a story here")
        txtField.contentVerticalAlignment = .top
        txtField.backgroundColor = .white
        return txtField
    }()
    
    lazy var plusButton: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "")
        btn.backgroundColor = UIColor.orange
        btn.isHidden = false
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(addStoryTask), for: .touchUpInside)
        btn.backgroundColor = .homeColour
        return btn
    }()
    
    lazy var startEstimatingButton: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Start Estimating")
        btn.isHidden = false
        btn.addTarget(self, action: #selector(startEstimating), for: .touchUpInside)
        return btn
    }()
    
    lazy var restartSprintButton: CustomButton = {
        let btn = CustomButton(frame: .zero, buttonText: "Restart")
        btn.isHidden = false
        btn.alpha = 0.6
        btn.addTarget(self, action: #selector(restartPlanningSession), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    lazy var endPlanningButton: CustomButton = {
        
        let btn = CustomButton(frame: .zero, buttonText: "End Planning")
        btn.isHidden = false
        btn.alpha = 0.6
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(endPlannigSession), for: .touchUpInside)
        return btn
    }()
    
    lazy var helperTextView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var helperTextLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.text = "Using Fibonacci card set. You can change it after the meeting ends."
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var confidenceLevelView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var confidenceTextLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.homeColour
        label.text = "❓Confidence level: idle"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    fileprivate func setupViews() {
        
        self.addSubview(self.storyTextBox)
        self.addSubview(self.plusButton)
        self.addSubview(self.startEstimatingButton)
        self.addSubview(self.restartSprintButton)
        self.addSubview(self.endPlanningButton)
        self.addSubview(self.helperTextView)
        self.helperTextView.addSubview(self.helperTextLabel)
        self.addSubview(self.confidenceLevelView)
        self.confidenceLevelView.addSubview(self.confidenceTextLabel)
        self.setupLayoutConstraints()
    }
    
    fileprivate func setupLayoutConstraints() {
        
        let width = SafeAreaFrame.width - 20
        let height = SafeAreaFrame.height * 0.5
        let labelSize = self.helperTextLabel.intrinsicContentSize.height + 20
        let confidenceLabelSize = self.confidenceTextLabel.intrinsicContentSize.height + 20
        
        self.anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        self.storyTextBox.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: width * 0.75, height: height * 0.25), padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        self.plusButton.anchor(top: self.topAnchor, leading: self.storyTextBox.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: width * 0.12, height: height * 0.1), padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 0))
        
        self.startEstimatingButton.anchor(top: self.storyTextBox.bottomAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: (width * 0.4) - 20, height: height * 0.1), padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        self.restartSprintButton.anchor(top: self.storyTextBox.bottomAnchor, leading: self.startEstimatingButton.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: (width * 0.2) - 10, height: height * 0.1), padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        self.endPlanningButton.anchor(top: self.storyTextBox.bottomAnchor, leading: self.restartSprintButton.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: (width * 0.4) - 10, height: height * 0.1), padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        self.helperTextView.anchor(top: self.startEstimatingButton.bottomAnchor, leading: self.startEstimatingButton.leadingAnchor, trailing: self.endPlanningButton.trailingAnchor, bottom: nil, size: CGSize(width: width, height: labelSize), padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        self.helperTextLabel.fillToSuperView()
        
        self.confidenceLevelView.anchor(top: self.helperTextView.bottomAnchor, leading: self.helperTextView.leadingAnchor, trailing: self.helperTextView.trailingAnchor, bottom: nil, size: CGSize(width: width, height: confidenceLabelSize), padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        self.confidenceTextLabel.fillToSuperView()
        
    }
    
    @objc fileprivate func startEstimating() {
        delegate?.didStartSession()
    }
    
    @objc func addStoryTask() {
        
        guard let storySummary =  self.storyTextBox.text else {return}
        delegate?.createStory(storySummary: storySummary)
    }
    
    @objc func endPlannigSession () {
        
        self.storyTextBox.text = ""
        delegate?.endPlanningSession()
    }
    
    
    @objc func restartPlanningSession () {
        
        self.storyTextBox.text = ""
        delegate?.restartPlanningSession()
    }
    

}
