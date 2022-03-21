
import UIKit
import Foundation

class TeamDetailsController: UIViewController {
    let cellReuseIdentifier = "teamDetailsCell"
    var model = [UserModel]()
    
    lazy var teamTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillUpModel()
        teamTableView.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        self.title = "Team Members"
        navigationController?.navigationBar.tintColor = UIColor.homeColour
        self.setupTableView()
        
    }
    
    fileprivate func setupTableView() {
        view.addSubview(self.teamTableView)
        self.teamTableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.teamTableView.register(TeamDetailsCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    fileprivate func fillUpModel() {
        
        let model = [UserModel(username: "Kingsley Charles", email: "kingsley108@yahoo.co.uk")]
        self.model.append(contentsOf: model)
    }
}

extension TeamDetailsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = model[indexPath.row]
        let cell = self.teamTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TeamDetailsCell
        cell.setCellAttributes(model: model)
        cell.backgroundColor = .alternativeHomeColour
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}


