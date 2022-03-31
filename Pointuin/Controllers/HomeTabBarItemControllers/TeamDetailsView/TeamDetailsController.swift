
import UIKit
import Foundation

class TeamDetailsController: UIViewController, ChatControllerRoute {
    
    let cellReuseIdentifier = "teamDetailsCell"
    var model = [UserProfile]()
    
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
        self.teamTableView.separatorColor = .clear
        self.title = "Team Members"
        self.setupTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = false
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    fileprivate func setupTableView() {
        view.addSubview(self.teamTableView)
        self.teamTableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.teamTableView.register(TeamDetailsCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    fileprivate func fillUpModel() {
        
        let model = [UserProfile(username: "Charlie Smith", email: "Csmith@yahoo.co.uk"),
                     UserProfile(username: "James Jones", email: "Jjones@yahoo.co.uk"),
                     UserProfile(username: "Richard Mill", email: "Rmill@yahoo.co.uk"),
                     UserProfile(username: "Fred Ani", email: "Fani@yahoo.co.uk"),
        ]
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
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func chatControllerSegue(with username: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "chatStoryBoard") as! ChatViewController
        vc.sendeeName = username
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


