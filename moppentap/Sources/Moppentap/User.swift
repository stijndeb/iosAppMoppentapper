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
        var name = "N.A."
        var password = "N.A."
        guard
            let email = String(bson["email"]),
            let username = String(bson["username"])
            //let password = String(bson["password"])
        else{
            return nil
        }
        if bson["name"] == nil {
            name = "N.A."
        }else{ name = String(describing: bson["name"])}
        
        if bson["password"] == nil {
            password = "N.A."
        }else{ name = String(describing: bson["password"])}
        
        
        
        self.init(name:name, email: email, username: username, password: password)
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
