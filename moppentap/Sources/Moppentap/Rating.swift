import Foundation
import MongoKitten

class Rating: Codable{
    var auteur: User
    var post: Post
    var beoordeling: Int
    var datum: Date
    
    init(auteur: User, post: Post, beoordeling: Int, datum: Date){
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
}

extension Rating{
    convenience init?(from bson: Document){
        print("rat")
        guard let auteurBSON = Document(bson["auteur"]),
            let auteur = User(from: auteurBSON),
            let postBSON = Document(bson["post"]),
            let post = Post(from: postBSON),
            let beoordeling = Int(bson["beoordeling"]),
            let datum = Date(bson["datum"])
        else{
            return nil
        }
        self.init(auteur: auteur, post: post, beoordeling: beoordeling, datum: datum)
    }
    func toBSON() -> Document{
        return[
            "auteur": auteur.toBSON(),
            "post": post.toBSON(),
            "beoordeling": beoordeling,
            "datum": datum
        ]
    }
    
}
