
import UIKit

class InfoDetailView: UIView {

    lazy var informationIcon: UIImageView = {
        let imgView = UIImageView()
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [.white, .orange])
            imgView.image = UIImage(systemName: "info.circle.fill", withConfiguration: config)
        } else {
            imgView.image = UIImage(systemName: "info.circle.fill")?.withTintColor(.orange)
        }
        return imgView
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "Now what?"
        title.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return title
    }()
    
    lazy var infoText: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
       let attributedText = NSMutableAttributedString(string: "You have to ask the team Admin\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .light)])
        attributedText.append(NSAttributedString(string: "to create a new session and join or\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .light)]))
        attributedText.append(NSAttributedString(string: "create a session by clicking on the button.\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10, weight: .light)]))
        textView.attributedText = attributedText
        textView.backgroundColor = .systemGray6
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
        self.addSubviews()
        self.addViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        
        self.addSubview(self.informationIcon)
        self.addSubview(self.title)
        self.addSubview(self.infoText)
    }
    
    fileprivate func addViewConstraints() {
        self.informationIcon.anchor(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, size: CGSize(width: 30, height: 30), padding: UIEdgeInsets(top: 8, left: 15, bottom: 0, right: 0))
        self.title.anchor(top: self.informationIcon.topAnchor, leading: self.informationIcon.trailingAnchor, trailing: nil, bottom: nil, padding: UIEdgeInsets(top: 0 , left: 10, bottom: 0, right: 0))
        self.infoText.anchor(top: self.title.bottomAnchor, leading: self.title.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
    }
    
    
}
