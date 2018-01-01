import Foundation
import MongoKitten

class Rating: Codable{
    var auteur: ObjectId
    var post: ObjectId
    var beoordeling: Int
    var datum: Date
    
    init(auteur: ObjectId, post: ObjectId, beoordeling: Int, datum: Date){
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
}

extension Rating{
    convenience init?(from bson: Document){
        print("rat")
        print(bson)
        guard let auteur = ObjectId(bson["user"]),
            let post = ObjectId(bson["post"]),
            let beoordeling = Int(bson["beoordeling"]),
            let datum = Date(bson["datum"])
        else{
            return nil
        }
        self.init(auteur: auteur, post: post, beoordeling: beoordeling, datum: datum)
    }
    func toBSON() -> Document{
        return[
            "auteur": auteur,
            "post": post,
            "beoordeling": beoordeling,
            "datum": datum
        ]
    }
    
}
