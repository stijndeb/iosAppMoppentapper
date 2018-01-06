import Foundation
import MongoKitten

class Comment: Codable {
    var id: ObjectId
    var inhoud: String
    var auteur: User
    var beoordeling: Int
    var post: ObjectId
    var datum: Date
    
    init(inhoud: String, auteur: User, post: ObjectId, beoordeling: Int, datum: Date, id: ObjectId){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.id = id
    }
    init(inhoud: String, auteur: User, post: ObjectId, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.id = ObjectId()
    }
    
    func objectId() -> String {
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
    }
    
}

extension Comment{
    convenience init?(from bson: Document){
        guard let inhoud = String(bson["inhoud"]),
            let auteurBSON = Array(bson["auteur"]),
            let beoordeling = Int(bson["beoordeling"]),
            let post = ObjectId(bson["post"]),
            let datum = Date(bson["datum"]),
            let id = ObjectId(bson["_id"])
            else{
                return nil
            }
        let auteur = auteurBSON.flatMap{ Document($0)}.flatMap { User(from: $0)}.first!
        self.init(inhoud: inhoud, auteur: auteur, post: post, beoordeling: beoordeling, datum: datum, id:id)
    }
    func toBSON() -> Document{
        return[
            "_id": id,
            "inhoud": inhoud,
            "auteur": auteur.id,
            "beoordeling": beoordeling,
            "post": post,
            "datum": datum
        ]
    }
}

