

class User: Codable{
    var name: String
    var email: String
    var username: String
    var password: String
    var id: ObjectId
    
    init(name: String, email: String, username: String, password: String){
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.id = ObjectId()
    }
    init(name: String, email: String, username: String, password: String, id:ObjectId){
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.id = id
    }
    
    
    
   
}


import MongoKitten

extension User{
    convenience init?(from bson: Document){
        let name = String(bson["name"]) ?? "N.A."
        let password = String(bson["password"]) ?? "N.A."
        
        guard
            let email = String(bson["email"]),
            let username = String(bson["username"]),
            let id = ObjectId(bson["_id"])
        else{
            return nil
        }
        
        self.init(name:name, email: email, username: username, password: password, id:id)
    }
    func toBSON() -> Document{
        return[
            "_id": id,
            "name": name,
            "email": email,
            "username": username,
            "password": password
        ]
    }
    
}
