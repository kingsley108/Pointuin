
import Foundation
import UIKit
import Firebase

var cardSet: [String] = ["0","1","2","3","5","8", "13" , "21" , "34" , "55", "89", "?"]
var imageCache = [String: UIImage]()
var otherUserPoints: String?

class EstimateController: UIViewController {
    
    let cellReuseIdentifier = "estimateDetailsCell"
    var isFinishedPaging = false
    
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    
    lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = "💤 Waiting on the next story"
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    
    lazy var estimateCollectionView: UICollectionView = {
        let collectonView = UICollectionView(frame: .zero,
                                             collectionViewLayout: UICollectionViewFlowLayout())
        collectonView.delegate = self
        collectonView.dataSource = self
        return collectonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        self.estimateCollectionView.backgroundColor = .white
        self.title = "Planning 5"
        navigationController?.navigationBar.tintColor = .white
        self.fetchCurrentStory()
        self.setupView()
    }
    
    fileprivate func fetchCurrentStory() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().getSessionStory(uid: uid) { story, err in

            if let err = err {
                print(err)
                return
            }

            guard let story = story else {return}
            self.pageTitle.text = story
            self.pageTitle.font = UIFont.boldSystemFont(ofSize: 18)
        }

    }
    
    fileprivate func setupView() {
        
        self.view.addSubview(self.pageTitle)
        self.view.addSubview(self.estimateCollectionView)
        self.estimateCollectionView.register(EstimatingCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        self.setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        self.pageTitle.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil,padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        let width = self.view.frame.width - 40
        let height = ((UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.height)! - 30 - self.pageTitle.intrinsicContentSize.height - 3) * 0.75
        self.height = height
        self.width = width
        
        self.estimateCollectionView.anchor(top: nil, leading: nil, trailing: nil, bottom: nil,size: CGSize(width: width, height: self.height))
        self.estimateCollectionView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.estimateCollectionView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
}

extension EstimateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! EstimatingCell
        cell.setCardValue(cardValue: cardSet[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.width - 80) / 3
        let height = (self.height - 120) / 4
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EstimatingCell
        guard let point = cell.point else {return}
        guard let title = self.title else {return}
        let controller = ConfirmEstimationController(point: point, title: title)
        navigationController?.pushViewController(controller, animated: true)
         
    }
}








