import Foundation

class Rating: Codable{
    var auteur: String
    var post: String
    var beoordeling: Int
    var datum: Date
    
    init(auteur: String, post: String, beoordeling: Int, datum: Date){
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
}
