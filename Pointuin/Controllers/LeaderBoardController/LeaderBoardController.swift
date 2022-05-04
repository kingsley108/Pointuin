
import UIKit
import Foundation

class LeaderBoardController: UIViewController {
    let cellReuseIdentifier = "leaderBoardCell"
    var model = [UserScore]()
    
    lazy var leaderBoardTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var dateString: String = {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter.string(from: currentDateTime)
    }()
    
    
    lazy var leaderBoardTitle: UILabel = {
        let label = UILabel()
        label.text = "Planning (\(dateString))"
        label.textColor = .homeColour
        label.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillUpModel()
        leaderBoardTableView.backgroundColor = .white
        view.backgroundColor = .white
        navigationItem.title = "LeaderBoard"
        navigationController?.navigationBar.tintColor = UIColor.homeColour
        self.leaderBoardTableView.separatorColor = .clear
        self.setupTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func setupTableView() {
        
        view.addSubview(self.leaderBoardTableView)
        view.addSubview(self.leaderBoardTitle)
        
        let labelSize = self.leaderBoardTitle.getIntrinsicHeight()
        
        self.leaderBoardTitle.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil, size: labelSize ,padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        self.leaderBoardTableView.anchor(top: self.leaderBoardTitle.topAnchor, leading: leaderBoardTitle.leadingAnchor, trailing: leaderBoardTitle.trailingAnchor, bottom: self.view.bottomAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        self.leaderBoardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    fileprivate func fillUpModel() {
        
        
        let userone = UserScore(username: "Kingsley Charles", points: 0)
        let usertwo = UserScore(username: "Charlie Smith", points: 3)
        let userthree = UserScore(username: "James Jones", points: 2)
        let userfour = UserScore(username: "Richard Mill", points: 2)
        let userfive = UserScore(username: "Fred Ani", points: 2)
        
        self.model.append(userone)
        self.model.append(usertwo)
        self.model.append(userthree)
        self.model.append(userfour)
        self.model.append(userfive)
        
        self.model = UserScore.getIcon(scores: self.model)
    }
}

extension LeaderBoardController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = model[indexPath.row]
        let cell = self.leaderBoardTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! LeaderboardCell
        cell.setCellAttributes(model: model)
        cell.backgroundColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}



