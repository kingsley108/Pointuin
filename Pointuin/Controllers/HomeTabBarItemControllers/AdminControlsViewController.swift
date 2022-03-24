//
//  ControlGroupControllersView.swift

import UIKit

class AdminControlsViewController: UIViewController {
    
    lazy var dateString: String = {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }()
    
    lazy var confirmPointuinTitle: UILabel = {
        let label = UILabel()
        label.text = "Planning (\(dateString))"
        label.textColor = .homeColour
        label.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .homeColour
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    
    lazy var timeAgoDisplayLabel: UILabel = {
        let label = UILabel()
//        let timeAgoDisplay = creationDate.timeAgoDisplay()
        label.text = "Started 3 hours ago"
        label.textColor = .homeColour
        label.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    


}
