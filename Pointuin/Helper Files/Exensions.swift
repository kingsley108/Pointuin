//
//  Exensions.swift
//  Tinder App
//
//  Created by Kingsley Charles on 16/03/2021.
//

import Foundation
import UIKit

class SafeAreaFrame {
    
    static let width = (UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.width)! 
    static let height = ((UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height))! 
    
}

enum Errors: Error {
    case couldNotMatch
}

extension UIColor {
    static let homeColour = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    static let alternativeHomeColour = #colorLiteral(red: 0.6085609794, green: 0.8245826364, blue: 1, alpha: 1)
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, size: CGSize = .zero, padding: UIEdgeInsets = .zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let topAnchorConstraint = top {
            topAnchor.constraint(equalTo: topAnchorConstraint, constant: padding.top).isActive = true
        }
        if let trailingAnchorConstraint = trailing {
            trailingAnchor.constraint(equalTo: trailingAnchorConstraint, constant: -padding.right).isActive = true
        }
        if let leadingAnchorConstraint = leading {
            leadingAnchor.constraint(equalTo: leadingAnchorConstraint, constant: padding.left ).isActive = true
        }
        if let bottomAnchorConstraint = bottom {
            bottomAnchor.constraint(equalTo: bottomAnchorConstraint, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func fillToSuperView() {
        anchor(top: superview!.topAnchor
               , leading: superview!.leadingAnchor, trailing: superview!.trailingAnchor, bottom: superview!.bottomAnchor)
    }
    
    func anchorSizeTo(view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func centerTo(view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}


extension String {
    var bool: Bool {
        switch self.lowercased() {
        case "true", "t", "yes", "y":
            return true
        case "false", "f", "no", "n", "":
            return false
        default:
           return false
        }
    }
}
