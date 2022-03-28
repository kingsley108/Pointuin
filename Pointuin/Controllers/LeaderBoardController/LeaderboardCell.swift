//
//  SettingsCell.swift
//  Settings Recreation (Live)
//
//  Created by Kingsley Charles on 22/05/2021.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    
    
    lazy var userTrophyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "envelope.fill")?.withTintColor(.blue)
        imageView.image?.withTintColor(.white)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    lazy var memberUsername: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 30, weight: .light)
        title.textColor = UIColor.homeColour
        return title
    }()
    
    lazy var userPointLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        title.textColor = UIColor.homeColour
        return title
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func addSubviews() {
        self.contentView.addSubview(self.userTrophyIcon)
        self.contentView.addSubview(self.memberUsername)
        self.contentView.addSubview(self.userPointLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        contentView.backgroundColor = .white
        
        let labelSize = self.userPointLabel.getIntrinsicHeight()
        
        self.userTrophyIcon.anchor(top: contentView.topAnchor, leading: self.contentView.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: 60, height: 60), padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0))
        
        self.memberUsername.anchor(top: self.userTrophyIcon.topAnchor, leading: self.userTrophyIcon.trailingAnchor, trailing: nil, bottom: nil,padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        
        self.userPointLabel.anchor(top: self.userTrophyIcon.topAnchor, leading: nil, trailing: self.trailingAnchor, bottom: nil, size:labelSize ,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    override func prepareForReuse() {
        self.memberUsername.text = nil
        self.userPointLabel.text = nil
        self.userTrophyIcon.image = nil
    }
    
    func setCellAttributes(model: UserScore) {
        self.memberUsername.text = model.username
        self.userTrophyIcon.image = model.icon
        self.userPointLabel.text = " \(model.points) pts"
        
    }

}


