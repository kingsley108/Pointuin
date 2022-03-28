
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
        self.leaderBoardTableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.leaderBoardTableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    fileprivate func fillUpModel() {
        
        
        let userone = UserScore(username: "Kingsley Charles", points: 5)
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



