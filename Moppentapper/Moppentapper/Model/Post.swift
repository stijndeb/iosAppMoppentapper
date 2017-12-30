class Post: Codable{
    var title: String
    var inhoud: String
    //var auteur: User
    //var beoordeling: [Rating] = []
    //var category: Category
    //var comments: [Comment] = []
    //var datum: Date
    
    init(title: String, inhoud: String){
        self.title = title
        self.inhoud = inhoud
    }
}


