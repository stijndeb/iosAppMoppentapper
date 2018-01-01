class Category: Codable{
    var name: String
    
    init(name: String){
        self.name = name
    }
}

import MongoKitten

extension Category{
    convenience init?(from bson: Document){
        print("cat")
        print(bson)
        guard let name = String(bson["name"]) else{
            return nil
        }
        self.init(name: name)
    }
    func toBSON() -> Document{
        return[
            "name": name
        ]
    }
    
}
