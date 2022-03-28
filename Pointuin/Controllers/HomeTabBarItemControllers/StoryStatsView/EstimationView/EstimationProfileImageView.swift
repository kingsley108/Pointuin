
import Foundation
import UIKit

class EstimationProfileImageView: UIImageView  {
    fileprivate let labelText: String?
    fileprivate let profileImage: UIImage?
    var lastURLUsedToLoadImage: String?
    
    
    var profileImageUrl: String? {
        didSet {
            
            guard let userProfileImageUrl = profileImageUrl else { return }
            
            self.loadImage(urlString: userProfileImageUrl)
        }
    }
    
    var viewLabel: String? {
        didSet{
            self.pointLabel.text = viewLabel
        }
    }
    
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
        
        let labelSize = self.pointLabel.getIntrinsicHeight()

        self.pointLabel.anchor(top: nil, leading: nil, trailing: nil, bottom: nil, size: labelSize)
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
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
            }.resume()
    }
    
    static func loadImage(urlString: String, completion: @escaping (UIImage) -> ()) {
       
        if let cachedImage = imageCache[urlString] {
           completion(cachedImage)
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            guard let imageData = data else { return }
            
            guard let photoImage = UIImage(data: imageData) else {return}
            imageCache[url.absoluteString] = photoImage
            print(" image is \(photoImage)" )
            completion(photoImage)
            
            }.resume()
        
        
    }
}
