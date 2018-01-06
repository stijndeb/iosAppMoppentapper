import Foundation

class Comment: Codable {
    var inhoud: String
    var auteur: User
    var beoordeling: Int
    var post: String
    var datum: Date
    var user: String
    
    init(inhoud: String, auteur: User, post: String, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = auteur
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.user = ""
    }
    
    init(inhoud: String, user: String, post: String, beoordeling: Int, datum: Date){
        self.inhoud = inhoud
        self.auteur = User(name: "", email: "", username: user, password: "")
        self.post = post
        self.beoordeling = beoordeling
        self.datum = datum
        self.user = user
    }
    
    
    
    private enum CodingKeys: CodingKey {
        case inhoud
        case auteur
        case beoordeling
        case post
        case datum
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inhoud, forKey: .inhoud)
        try container.encode(user, forKey: .auteur)
        try container.encode(datum, forKey: .datum)
        try container.encode(beoordeling, forKey: .beoordeling)
        try container.encode(post, forKey: .post)
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
        self.user = ""
    }
}
