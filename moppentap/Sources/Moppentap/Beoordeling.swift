import Foundation
import MongoKitten

//class die gebruikt wordt om de tijdelijke rating in op te slaan
class Beoordeling: Codable{
    var auteur: String
    var post: String
    var beoordeling: Int
    var datum: Date
 
    init(auteur: String, post: String, beoordeling: Int, datum: Date){
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.auteur = auteur
    }
}

extension Beoordeling{
    convenience init?(from bson: Document){
        guard let auteur = String(bson["user"]),
            let post = String(bson["post"]),
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

