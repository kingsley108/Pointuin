
import Foundation
import UIKit

class EstimationProfileImageView: UIImageView  {
    fileprivate let labelText: String?
    fileprivate let profileImage: UIImage?
    
    fileprivate lazy var pointLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20)
        return lbl
    }()
    
    
     init(frame: CGRect, labelText: String?, image: UIImage?) {
        self.labelText = labelText
        self.profileImage = image
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func anchorLabel() {
        
        let labelHeight = self.pointLabel.intrinsicContentSize.height
        let labelWidth = self.pointLabel.intrinsicContentSize.width
        
        self.pointLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: labelWidth, height: labelHeight))
        self.pointLabel.centerTo(view: self)
    }
    
    fileprivate func setupView() {
        
        self.image = self.profileImage
        self.pointLabel.text = self.labelText
        self.backgroundColor = .homeColour
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = ((SafeAreaFrame.width / 5) - 20) / 2
        
        self.addSubview(self.pointLabel)
        self.anchorLabel()
        
    }
    
    
}
