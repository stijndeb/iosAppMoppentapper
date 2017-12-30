import Foundation
import MongoKitten

class Comment: Codable {
    var inhoud: String
    var auteur: User
    var beoordeling: Int
    var post: Post
    var datum: Date
    
    init(inhoud: String, auteur: User, post: Post, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
    
}

extension Comment{
    convenience init?(from bson: Document){
        print("com")
        guard let inhoud = String(bson["inhoud"]),
            let auteurBSON = Document(bson["auteur"]),
            let auteur = User(from: auteurBSON),
            let beoordeling = Int(bson["beoordeling"]),
            let postBSON = Document(bson["post"]),
            let post = Post(from: postBSON),
            let datum = Date(bson["datum"]) else{
                return nil
            }
        self.init(inhoud: inhoud, auteur: auteur, post: post, beoordeling: beoordeling, datum: datum)
    }
    func toBSON() -> Document{
        return[
            "inhoud": inhoud,
            "auteur": auteur.toBSON(),
            "beoordeling": beoordeling,
            "post": post.toBSON(),
            "datum": datum
        ]
    }
}

