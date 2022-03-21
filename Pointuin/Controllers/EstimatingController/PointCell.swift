
//  PointCell.swift
//  InstagramFirebase

import UIKit

class PointCell: UICollectionViewCell {
    
    lazy var photoImageView: UIView = {
        let iv = UIView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .alternativeHomeColour
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var cardValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lbl.textColor = .homeColour
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        self.addSubview(photoImageView)
        self.addSubview(cardValueLabel)
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        self.cardValueLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil,size: CGSize(width: 200, height: 30))
        self.cardValueLabel.centerXAnchor.constraint(equalTo: self.photoImageView.centerXAnchor).isActive = true
        self.cardValueLabel.centerYAnchor.constraint(equalTo: self.photoImageView.centerYAnchor).isActive = true
    }
    
    func setCardValue(cardValue: Int) {
        cardValueLabel.text = "\(cardValue)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

