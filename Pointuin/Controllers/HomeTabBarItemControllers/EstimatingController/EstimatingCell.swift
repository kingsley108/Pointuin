
//  PointCell.swift
//  InstagramFirebase

import UIKit

class EstimatingCell: UICollectionViewCell {
    
    
    
    var point: String? {
        get {
            guard let estimatePoint = pointerView.userPoint else {return nil}
            return estimatePoint
        }
    }
    
    private lazy var pointerView: PointerView = {
        let pointerView = PointerView()
        return pointerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        self.addSubview(self.pointerView)
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.pointerView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    func setCardValue(cardValue: String) {
        self.pointerView.configureWithPoint(pointValue: cardValue)
    }
    
    override func prepareForReuse() {
        self.pointerView.configureWithPoint(pointValue: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

