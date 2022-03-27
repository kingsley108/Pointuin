//
//  EstimationView.swift
//  Pointuin
//
//  Created by Kingsley Charles on 23/03/2022.
//

import UIKit

class EstimationView: UIView {
    
    fileprivate var imageProfileUrl: String
    fileprivate let cardPoints = cardSet
    
    var cUserPoint: String? {
        didSet {
            self.setupCardStats()
        }
    }
    init(profileUrl: String) {
        self.imageProfileUrl = profileUrl
        super.init(frame: .zero)
    }
    
    lazy var viewHeaderTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Estimations"
        label.textColor = .homeColour
        return label
    }()
    
   
    
    lazy var otherUserEstimationView: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: "5", image: nil)
        return imgView
    }()
    
    lazy var currentUserEstimationView: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: "2", image: nil)
        return imgView
    }()
    
    lazy var userProfile: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: nil, image: #imageLiteral(resourceName: "user2"))
        return imgView
    }()
    
    lazy var userProfile2: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: nil, image: #imageLiteral(resourceName: "user5"))
        return imgView
    }()
    
    lazy var userProfile3: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: nil, image: #imageLiteral(resourceName: "user1"))
        return imgView
    }()
    
    lazy var userProfile4: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: nil, image: #imageLiteral(resourceName: "user3"))
        return imgView
    }()
    
    lazy var currentUserProfile: EstimationProfileImageView = {
        let imgView = EstimationProfileImageView(frame: .zero, labelText: nil, image: #imageLiteral(resourceName: "user4"))
        imgView.profileImageUrl = self.imageProfileUrl
        imgView.backgroundColor = .white
        return imgView
    }()
    
     init(frame: CGRect, profileUrl: String) {
        self.imageProfileUrl = profileUrl
         super.init(frame: .zero)
        self.setupConstraintsToView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func addSubViews() {
        self.addSubview(self.viewHeaderTitle)
        self.addSubview(self.otherUserEstimationView)
        self.addSubview(self.currentUserEstimationView)
        self.addSubview(self.userProfile)
        self.addSubview(self.userProfile2)
        self.addSubview(self.userProfile3)
        self.addSubview(self.userProfile4)
        self.addSubview(self.currentUserProfile)
    }
    
    fileprivate func setupConstraintsToView() {
        self.addSubViews()
        
        let size = (SafeAreaFrame.width / 5) - 20
        let labelHeight = self.viewHeaderTitle.intrinsicContentSize.height
        let labelWidth = self.viewHeaderTitle.intrinsicContentSize.width
        
        self.viewHeaderTitle.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: labelWidth, height: labelHeight))
        
        self.otherUserEstimationView.anchor(top: self.viewHeaderTitle.bottomAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        self.userProfile.anchor(top: self.otherUserEstimationView.topAnchor, leading: self.otherUserEstimationView.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
        self.userProfile2.anchor(top: self.otherUserEstimationView.topAnchor, leading: self.userProfile.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
        
        self.userProfile3.anchor(top: self.otherUserEstimationView.topAnchor, leading: self.userProfile2.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
        
        self.userProfile4.anchor(top: self.otherUserEstimationView.topAnchor, leading: self.userProfile3.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
        self.currentUserEstimationView.anchor(top: self.otherUserEstimationView.bottomAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        self.currentUserProfile.anchor(top: self.currentUserEstimationView.topAnchor, leading: self.currentUserEstimationView.trailingAnchor, trailing: nil, bottom: nil, size: CGSize(width: size, height: size), padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        
    }
    
    fileprivate func setupCardStats() {
        
        self.currentUserEstimationView.viewLabel = self.cUserPoint
        var arr = self.cardPoints.filter { $0 != self.cUserPoint }
        arr.remove(at: 0)
        //Removes first element which most times we will never use

        guard let randomElement = arr.randomElement() else {return}
        self.otherUserEstimationView.viewLabel = randomElement
        
        
    }
    
    
}
