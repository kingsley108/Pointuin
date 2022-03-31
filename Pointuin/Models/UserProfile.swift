import Foundation
import UIKit


struct UserProfile {
    let username: String
    let email: String
    let initials: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.initials = self.username.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
}


struct User {
    let uid: String
    let username: String
    let email: String
    var initials: String
    var title: String
    var number: String
    let team: String
    let acessLevel: String
    let profileImageUrl: String
    let sessionID: String
    let sessionStatus: String
    let voted: String
    let pointSelected: String?
    var adminSessionOn: Bool? = nil
    let storySummary: String?
    
    init(uid: String, dictionary: [String: Any])
    {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"]  as? String ?? ""
        self.initials = self.username.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first)" }
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.team = dictionary["team"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.acessLevel = dictionary["acess"] as? String ?? ""
        self.number = dictionary["number"] as? String ?? ""
        self.sessionID = dictionary["sessionID"] as? String ?? ""
        self.sessionStatus = dictionary["sessionStatus"] as? String ?? "noSession"
        self.voted = dictionary["hasVoted"] as? String ?? "false"
        self.pointSelected = dictionary["pointSelected"] as? String
        if let sessionOn = dictionary["sessionOn"] as? String {
            self.adminSessionOn = sessionOn.bool
        }
        self.storySummary = dictionary["storySummary"] as? String
    }
}

struct UserScore {
    
    let username: String
    let points: Int
    var icon: UIImage?
    
    
    init(username: String, points: Int) {
        
        self.username = username
        self.points = points
    }
    
    static func getIcon(scores: [UserScore]) -> [UserScore] {
        
        var sortedArr = scores.sorted(by: {$0.points > $1.points} )
        sortedArr[0].icon = #imageLiteral(resourceName: "gold")
        sortedArr[1].icon = #imageLiteral(resourceName: "silver")
        
        for user in sortedArr.indices {
            if sortedArr[user].icon == nil {
                sortedArr[user].icon = #imageLiteral(resourceName: "bronze")
            }
        }
        
        return sortedArr
        
    }
}
