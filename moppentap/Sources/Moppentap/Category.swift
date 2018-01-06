class Category: Codable{
    var name: String
    var id: ObjectId
    
    init(name: String, id: ObjectId){
        self.name = name
        self.id = id
    }
}

import MongoKitten

extension Category{
    convenience init?(from bson: Document){
        guard let name = String(bson["name"]),
            let id = ObjectId(bson["_id"])
        else{
            return nil
        }
        self.init(name: name, id: id)
    }
    func toBSON() -> Document{
        return[
            "_id": id,
            "name": name
        ]
    }
    
}
