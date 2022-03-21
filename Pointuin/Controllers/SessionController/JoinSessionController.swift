
import UIKit
import Foundation

class JoinSessionController: UIViewController {
    
    lazy var joinSessionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Join A Session", for: .normal)
        btn.layer.cornerRadius = 4
        btn.backgroundColor = UIColor.homeColour
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        btn.addTarget(self, action: #selector(joinSession), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Join Session"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc fileprivate func joinSession() {
        
    }
    
    
    
}
