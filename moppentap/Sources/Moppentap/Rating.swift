import Foundation
import MongoKitten

class Rating: Codable{
    var auteur: ObjectId
    var post: ObjectId
    var beoordeling: Int
    var datum: Date
    var auteurNaam: String
    var id: ObjectId
    
    init(auteur: ObjectId, post: ObjectId, beoordeling: Int, datum: Date, id: ObjectId){
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.auteurNaam = ""
        self.id = id
    }
    
    //correct objectId genereren
    func objectId() -> String {
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
    }
    
    
    init(auteur: ObjectId, post: String, beoordeling: Int, datum: Date){
        do {
            self.post = try ObjectId(post)
        }catch{
            self.post = ObjectId()
        }
        self.auteur = auteur
        self.beoordeling = beoordeling
        self.datum = datum
        self.id = ObjectId()
        self.auteurNaam = ""
    }
}

extension Rating{
    convenience init?(from bson: Document){
        guard let auteur = ObjectId(bson["user"]),
            let post = ObjectId(bson["post"]),
            let beoordeling = Int(bson["beoordeling"]),
            let datum = Date(bson["datum"]),
            let id = ObjectId(bson["_id"])
        else{
            return nil
        }
        self.init(auteur: auteur, post: post, beoordeling: beoordeling, datum: datum, id: id)
    }
    func toBSON() -> Document{
        return[
            "_id": id,
            "user": auteur,
            "post": post,
            "beoordeling": beoordeling,
            "datum": datum
        ]
    }
    
}
