//
//  PointerView.swift
//  Pointuin
//
//  Created by Kingsley Charles on 22/03/2022.
//

import UIKit

class PointerView: UIView {
    
    var userPoint: String? {
        set {
            self.cardValueLabel.text = newValue
        }
        get {
            return self.cardValueLabel.text
        }
    }
    
    lazy var photoImageView: UIView = {
        let iv = UIView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .alternativeHomeColour
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var cardValueLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        self.addSubview(photoImageView)
        self.photoImageView.addSubview(self.cardValueLabel)
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.photoImageView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        self.cardValueLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil,size: CGSize(width: 200, height: 30))
        self.cardValueLabel.centerXAnchor.constraint(equalTo: self.photoImageView.centerXAnchor).isActive = true
        self.cardValueLabel.centerYAnchor.constraint(equalTo: self.photoImageView.centerYAnchor).isActive = true
    }
    
    func configureWithPoint(pointValue: String?) {
        cardValueLabel.text = pointValue
    }
    
}
