import Foundation


struct UserModel {
    let username: String
    let email: String
    var title: String?
    var number: String?
    
    init(username: String, email: String) {
        self.username = username
        self.email = email
    }
}
