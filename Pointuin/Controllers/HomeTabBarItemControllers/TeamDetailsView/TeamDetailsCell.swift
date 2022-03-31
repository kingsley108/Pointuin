//
//  SettingsCell.swift
//  Settings Recreation (Live)
//
//  Created by Kingsley Charles on 22/05/2021.
//

import UIKit

protocol ChatControllerRoute{
    
    func chatControllerSegue(with username: String)
}

class TeamDetailsCell: UITableViewCell {
    
    var delegate: ChatControllerRoute?
    
    lazy var memberInitialsView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60 / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.image?.withTintColor(.white)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    lazy var messageIcon: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setImage(UIImage(systemName: "envelope.fill")?.withTintColor(.blue), for: .normal)
        btn.imageView?.image?.withTintColor(.white)
        btn.imageView?.clipsToBounds = true
        btn.addTarget(self, action: #selector(routeToMessageController), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var memberUsername: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        title.textColor = UIColor.homeColour
        return title
    }()
    
    lazy var memberInitials: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
        self.contentView.addSubview(self.memberInitialsView)
        self.memberInitialsView.addSubview(self.memberInitials)
        self.contentView.addSubview(self.memberUsername)
        self.contentView.addSubview(self.messageIcon)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        contentView.backgroundColor = .alternativeHomeColour
        
        self.memberInitialsView.anchor(top: topAnchor, leading: self.leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: 60, height: 60), padding: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0))
        self.memberInitials.anchor(top: nil, leading: nil, trailing: nil, bottom: nil,size: CGSize(width: 200, height: 30))
        self.memberInitials.centerXAnchor.constraint(equalTo: memberInitialsView.centerXAnchor).isActive = true
        self.memberInitials.centerYAnchor.constraint(equalTo: memberInitialsView.centerYAnchor).isActive = true
        self.memberUsername.anchor(top: self.memberInitialsView.topAnchor, leading: self.memberInitialsView.trailingAnchor, trailing: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0))
        self.messageIcon.anchor(top: self.memberUsername.topAnchor, leading: nil, trailing: self.trailingAnchor, bottom: nil, size: CGSize(width: 25,height: 25), padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8))
    }
    
    override func prepareForReuse() {
        self.memberUsername.text = nil
        self.memberInitials.text = nil
    }
    
    func setCellAttributes(model: UserProfile) {
        self.memberUsername.text = model.username
        self.memberInitials.text = model.initials
    }
    
    
    @objc func routeToMessageController() {
        guard let username = self.memberUsername.text else {return}
        delegate?.chatControllerSegue(with: username)
    }
}

