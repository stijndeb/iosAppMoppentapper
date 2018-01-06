import Foundation
import MongoKitten
import ExtendedJSON

class Post: Codable{
    var id: ObjectId
    var title: String
    var inhoud: String
    var auteur: User
    var beoordeling: [Rating] = []
    var category: Category
    var comments: [Comment] = []
    var datum: Date
    
    init(id: ObjectId, title: String, inhoud: String, auteur: User, category: Category, datum: Date){
        self.id = id
        self.title = title
        self.inhoud = inhoud
        self.auteur = auteur
        self.category = category
        self.datum = datum
    }

}



extension Post{
    convenience init?(from json: Document){
        
        guard let title = String(json["title"]),
            let id = ObjectId(json["_id"]),
            let inhoud = String(json["inhoud"]),
            let auteurBSON = Array(json["auteur"]),
            let beoordelingBSON = Array(json["beoordeling"]),
            let categoryBSON = Array(json["category"]),
            let commentsBSON = Array(json["comments"]),
            let datum = Date(json["datum"])
            else{
                return nil
            }
        
        //ookal zijn auteur en category geen lijst in het post model
        //toch maakt de "lookup" methode hier een lijst van
        //we pakken dus gewoon het eerste element van de "lijst"
        let auteur = auteurBSON.flatMap{ Document($0)}.flatMap { User(from: $0)}.first!
        let category = categoryBSON.flatMap{ Document($0)}.flatMap { Category(from: $0)}.first!
        
        self.init(id: id, title: title, inhoud: inhoud, auteur: auteur, category: category, datum:datum)
        
        beoordeling = beoordelingBSON.flatMap { Document($0)}.flatMap { Rating(from: $0)}
        comments = commentsBSON.flatMap { Document($0)}.flatMap { Comment(from: $0)}
    }
    func toBSON() -> Document{
        return[
            "_id": id,
            "title": title,
            "inhoud": inhoud,
            "auteur": auteur.id,
            "beoordeling": beoordeling.map { $0.id},
            "category": category.id,
            "comments": comments.map {$0.id},
            "datum": datum
            
        ]
    }
    
}
