
import Kitura
import KituraContracts
import LoggerAPI
import ExtendedJSON

private let posts = database["posts"]
private let category = database["categories"]
private let comment = database["comments"]
private let rating = database["ratings"]
private let users = database["users"]



func configureCategoryRouter(on router: Router){
    router.get("/", handler: getAllCategories)
    router.post("/", handler: addCategorie)
    
}

//wordt niet gebruikt in mijn project, maar het blijft staan voor later gebruik

private func getAllCategories(completion: ([Category]?, RequestError?)  -> Void) {
    do {
        let results = try category.find().flatMap(Category.init)
        completion(results, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}


private func addCategorie(categorie: Category, completion: (Category?, RequestError?) -> Void) {
    do {
        guard try category.count(["name": category.name]) == 0 else{
            completion(nil, .conflict)
            return
        }
        try category.insert(categorie.toBSON())
        completion(categorie, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}



