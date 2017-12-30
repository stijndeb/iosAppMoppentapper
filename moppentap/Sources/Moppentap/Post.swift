import Foundation
import MongoKitten
import ExtendedJSON

class Post: Codable{
    var title: String
    var inhoud: String
    var auteur: User
    var beoordeling: [Rating] = []
    var category: Category
    var comments: [Comment] = []
    var datum: Date
    
    init(title: String, inhoud: String, auteur: User, category: Category, datum: Date){
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
        print(json)
        //let json = bson.makeExtendedJSON().serializedString()
        print("hier")
        guard let title = String(json["title"]),
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
        self.init(title: title, inhoud: inhoud, auteur: auteur, category: category, datum:datum)
        
        beoordeling = beoordelingBSON.flatMap { Document($0)}.flatMap { Rating(from: $0)}
        comments = commentsBSON.flatMap { Document($0)}.flatMap { Comment(from: $0)}
    }
    func toBSON() -> Document{
        return[
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
