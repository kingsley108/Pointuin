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
    
    fileprivate var estimationView: EstimationView = {
        let view = EstimationView()
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
        self.circularProgress.progressColor = UIColor.homeColour
        self.circularProgress.trackColor = UIColor.alternativeHomeColour
        self.circularProgress.tag = 101
        self.constraintToView()
        
        //animate progress
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.1)
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
        
        
        let labelHeight = self.progressLabel.intrinsicContentSize.height
        let labelWidth = self.progressLabel.intrinsicContentSize.width
        self.progressLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: labelWidth, height: labelHeight))
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
