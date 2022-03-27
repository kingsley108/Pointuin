import Foundation


struct UserProfile {
    let username: String
    let email: String
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
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
    
    init(uid: String, dictionary: [String: Any])
    {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"]  as? String ?? ""
        self.initials = self.username.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
        self.team = dictionary["team"] as? String ?? "My Team"
        self.title = dictionary["title"] as? String ?? ""
        self.acessLevel = dictionary["acess"] as? String ?? ""
        self.number = dictionary["number"] as? String ?? ""
        self.sessionID = dictionary["sessionID"] as? String ?? ""
        self.sessionStatus = dictionary["sessionStatus"] as? String ?? "noSession"
        self.voted = dictionary["voted"] as? String ?? "false"
        self.pointSelected = dictionary["pointSelected"] as? String
    }
}
