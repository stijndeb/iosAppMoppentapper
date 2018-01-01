import Foundation
import MongoKitten

class Comment: Codable {
    var inhoud: String
    var auteur: User
    var beoordeling: Int
    var post: ObjectId
    var datum: Date
    
    init(inhoud: String, auteur: User, post: ObjectId, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
    
}

extension Comment{
    convenience init?(from bson: Document){
        print("comm")
        print(bson)
        guard let inhoud = String(bson["inhoud"]),
            let auteurBSON = Array(bson["auteur"]),
            let beoordeling = Int(bson["beoordeling"]),
            let post = ObjectId(bson["post"]),
            let datum = Date(bson["datum"]) else{
                return nil
            }
        let auteur = auteurBSON.flatMap{ Document($0)}.flatMap { User(from: $0)}.first!
        self.init(inhoud: inhoud, auteur: auteur, post: post, beoordeling: beoordeling, datum: datum)
    }
    func toBSON() -> Document{
        return[
            "inhoud": inhoud,
            "auteur": auteur.toBSON(),
            "beoordeling": beoordeling,
            "post": post,
            "datum": datum
        ]
    }
}

