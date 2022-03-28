//
//  StoryStatsViewController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 22/03/2022.
//

import UIKit

class StoryStatsViewController: UIViewController {
    
    fileprivate var progressValue: Float = 0.8
    fileprivate let circularProgress = CircularProgress(frame: CGRect(x: 10.0, y: 30.0, width: 200.0, height: 200.0))
    fileprivate let userPoint: String
    fileprivate let profileUrl: String
    
    
    init(userPoint: String, profileUrl: String) {
        self.userPoint = userPoint
        self.profileUrl = profileUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var progressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "\(Int(self.progressValue * 100))"
        lbl.textColor = .homeColour
        lbl.sizeToFit()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 40)
        lbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return lbl
        
    }()
    
    fileprivate lazy var estimationView: EstimationView = {
        let view = EstimationView(frame: .zero, profileUrl: self.profileUrl)
        view.cUserPoint = self.userPoint
        return view
    }()
    
    lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .homeColour
        label.text = "Analysis of the results"
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        self.circularProgress.progressColor = UIColor.homeColour
        self.circularProgress.trackColor = UIColor.alternativeHomeColour
        self.circularProgress.tag = 101
        self.constraintToView()
        
        //animate progress
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func constraintToView() {
        let width = SafeAreaFrame.width * 0.9
        let height = SafeAreaFrame.height * 0.75
        
        self.view.addSubview(self.contentView)
        self.contentView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: width, height: height))
        self.contentView.centerTo(view: self.view)
        
        self.contentView.addSubview(self.pageTitle)
        self.pageTitle.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, trailing: nil, bottom: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        
        self.contentView.addSubview(self.circularProgress)
        self.circularProgress.addSubview(self.progressLabel)
        self.circularProgress.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.circularProgress.anchor(top: self.pageTitle.bottomAnchor, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: 200, height: 200), padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        
        
        let labelSize = self.progressLabel.getIntrinsicHeight()
        
        self.progressLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: labelSize)
        self.progressLabel.centerXAnchor.constraint(equalTo: self.circularProgress.centerXAnchor).isActive = true
        self.progressLabel.centerYAnchor.constraint(equalTo: self.circularProgress.centerYAnchor).isActive = true
        
        self.contentView.addSubview(self.estimationView)
        self.estimationView.anchor(top: self.circularProgress.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor, padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        
    }
    
    
    
    @objc func animateProgress()
    {
        let cp = self.view.viewWithTag(101) as! CircularProgress
        cp.setProgressWithAnimation(duration: 1.0, value: self.progressValue)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
