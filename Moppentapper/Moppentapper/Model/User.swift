import Foundation

class User: Codable{
    var name: String
    var email: String
    var username: String
    var password: String
    
    init(name: String, email: String, username: String, password: String){
        self.name = name
        self.email = email
        self.username = username
        self.password = password
    }
    
}
