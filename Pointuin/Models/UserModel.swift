import Foundation


struct UserModel {
    let username: String
    let email: String
    var initials: String
    var title: String?
    var number: String?
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
        self.initials = self.username.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
}
