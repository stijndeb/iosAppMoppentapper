import Foundation

class Post: Codable{
    var id: String
    var title: String
    var inhoud: String
    var auteur: User
    var beoordeling: [Rating] = []
    var category: Category
    var comments: [Comment] = []
    var datum: Date
    
    init(id: String, title: String, inhoud: String, auteur: User, category: Category, datum: Date, comments: [Comment], beoordeling: [Rating]){
        self.id = id
        self.title = title
        self.inhoud = inhoud
        self.auteur = auteur
        self.category = category
        self.datum = datum
        self.comments = comments
        self.beoordeling = beoordeling
    }
    
    func score() -> Int {
        var score1 = 0
        
        if(beoordeling.count > 0){
            for punt in beoordeling {
                score1 += punt.beoordeling
            }
        
            score1 = score1 / beoordeling.count
        }
        return score1
    }
    
    
    private enum CodingKeys: CodingKey{
        case id
        case title
        case inhoud
        case auteur
        case beoordeling
        case category
        case comments
        case datum
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(inhoud, forKey: .inhoud)
        try container.encode(auteur, forKey: .auteur)
        try container.encode(category, forKey: .category)
        try container.encode(datum, forKey: .datum)
        try container.encode(comments, forKey: .comments)
        try container.encode(beoordeling, forKey: .beoordeling)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let inhoud = try container.decode(String.self, forKey: .inhoud)
        let auteur = try container.decode(User.self, forKey: .auteur)
        let datum = try container.decode(Date.self, forKey: .datum)
        let category = try container.decode(Category.self, forKey: .category)
        let beoordeling = try container.decode([Rating].self, forKey: .beoordeling)
        let comments = try container.decode([Comment].self, forKey: .comments)
        let id = try container.decode(String.self, forKey: .id)
        
        self.id = id
        self.title = title
        self.inhoud = inhoud
        self.auteur = auteur
        self.datum = datum
        self.category = category
        self.beoordeling = beoordeling
        self.comments = comments
        
        
        
    }
}




