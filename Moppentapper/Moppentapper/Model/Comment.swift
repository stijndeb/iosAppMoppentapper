import Foundation

class Comment: Codable {
    var inhoud: String
    var auteur: User
    var beoordeling: Int
    var post: String
    var datum: Date
    
    init(inhoud: String, auteur: User, post: String, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
    }
    
    private enum CodingKeys: CodingKey {
        case inhoud
        case auteur
        case beoordeling
        case post
        case datum
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let inhoud = try container.decode(String.self, forKey: .inhoud)
        let auteur = try container.decode(User.self, forKey: .auteur)
        let beoordeling = try container.decode(Int.self, forKey: .beoordeling)
        let post = try container.decode(String.self, forKey: .post)
        let datum = try container.decode(Date.self, forKey: .datum)
        
        self.inhoud = inhoud
        self.auteur = auteur
        self.beoordeling = beoordeling
        self.post = post
        self.datum = datum
        
    }
}
