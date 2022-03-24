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
    let profileImageUrl: String?
    
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
    }
}
