//
//  CustomTextField.swift
//  Pointuin

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.backgroundColor = UIColor(white: 0, alpha: 0.03)
        self.borderStyle = .roundedRect
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        self.font = UIFont.systemFont(ofSize: 14)
        self.isUserInteractionEnabled = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PlaceHolderTextView: UITextView, UITextViewDelegate{
    var placeholderText = "Write A Story Here"
    
    let textView = UITextView()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: nil)
        self.font = UIFont.systemFont(ofSize: 14)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        textColor = .black
        delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText{
            placeholderText = textView.text
            textView.text = ""
            textView.textColor = .darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeholderText
            textColor = .lightGray
        }
        
    }
}



class InformationLabel: UITextView {
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.textColor = .black
        self.isEditable = false
        self.backgroundColor = superview?.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class VotingInformationView: UIView {
    
    lazy var iconSwitch: UISwitch = {
        let aSwitch = UISwitch()
        aSwitch.isOn = true
        return aSwitch
    }()
    
    lazy var switchLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "i'm voting"
        return lbl
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addConstraintsToView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraintsToView() {
        self.addSubview(iconSwitch)
        self.addSubview(switchLabel)
        
        iconSwitch.anchor(top: nil, leading: nil, trailing: trailingAnchor, bottom: nil)
        switchLabel.anchor(top: nil, leading: leadingAnchor, trailing: nil, bottom: nil)
        iconSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        switchLabel.centerYAnchor.constraint(equalTo: iconSwitch.centerYAnchor).isActive = true
    }
     
}
