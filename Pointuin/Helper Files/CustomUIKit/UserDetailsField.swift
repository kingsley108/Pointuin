//
//  DetailsField.swift
//  Tinder App
//
//  Created by Kingsley Charles on 27/03/2021.
//

import UIKit

class UserDetailsField: UITextField {
    
    let insets: UIEdgeInsets
    
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)) {
        self.insets = insets
        super.init(frame: .zero)
        self.textColor = .black
        self.backgroundColor = .white
        layer.cornerRadius = 25
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    
}
