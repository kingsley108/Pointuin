
//  PointCell.swift
//  InstagramFirebase

import UIKit

class EstimatingCell: UICollectionViewCell {
    
    var pointCard: PointerView {
        get {
            return self.pointerCellView
        }
    }
    
    private lazy var pointerCellView: PointerView = {
        let pointerView = PointerView()
        return pointerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        self.addSubview(self.pointerCellView)
        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.pointerCellView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    func setCardValue(cardValue: String) {
        self.pointerCellView.configureWithPoint(pointValue: cardValue)
    }
    
    override func prepareForReuse() {
        self.pointerCellView.configureWithPoint(pointValue: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

