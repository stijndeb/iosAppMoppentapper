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
        print("ok")
    }
   
}


import MongoKitten

extension User{
    convenience init?(from bson: Document){
        print("user")
        print(bson)
        guard let name = String(bson["name"]),
            let email = String(bson["email"]),
            let username = String(bson["username"]),
            let password = String(bson["password"])
        else{
            print("fuck")
            return nil
        }
        self.init(name: name, email: email, username: username, password: password)
    }
    func toBSON() -> Document{
        return[
            "name": name,
            "email": email,
            "username": username,
            "password": password
        ]
    }
    
}
