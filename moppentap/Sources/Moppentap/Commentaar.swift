import Foundation
import MongoKitten

class Commentaar: Codable {
    var inhoud: String
    var auteur: String
    var beoordeling: Int
    var post: String
    var datum: Date
    
    init(inhoud: String, user: String, post: String, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = user
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
    
}


