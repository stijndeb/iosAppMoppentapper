import Foundation
import MongoKitten
import ExtendedJSON

class Post: Codable{
    var id: String
    var title: String
    var inhoud: String
    var auteur: User
    var beoordeling: [Rating] = []
    var category: Category
    var comments: [Comment] = []
    var datum: Date
    
    init(id: String, title: String, inhoud: String, auteur: User, category: Category, datum: Date){
        self.id = id
        self.title = title
        self.inhoud = inhoud
        self.auteur = auteur
        self.category = category
        self.datum = datum
        print(title + "1")
    }

}



extension Post{
    convenience init?(from json: Document){
        print("post")
        print(json)
        //let json = bson.makeExtendedJSON().serializedString()
        guard let title = String(json["title"]),
            let id = String(json["_id"]),
            let inhoud = String(json["inhoud"]),
            let auteurBSON = Array(json["auteur"]),
            //let auteur = User(from: auteurBSON)
            let beoordelingBSON = Array(json["beoordeling"]),
            let categoryBSON = Array(json["category"]),
            //let category = Category(from: categoryBSON),
            let commentsBSON = Array(json["comments"]),
            let datum = Date(json["datum"])
            else{
                return nil
            }
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
            "auteur": auteur.toBSON(),
            "beoordeling": beoordeling.map { $0.toBSON()},
            "category": category.toBSON(),
            "comments": comments.map {$0.toBSON()},
            "datum": datum
            
        ]
    }
    
}
