
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
    //router.get("/", handler: getProject)
    //router.put("/", handler: updateProject)
    //router.delete("/", handler: deleteProject)
    
}

// Codable Routing API

// GET /projects
private func getAllCategories(completion: ([Category]?, RequestError?)  -> Void) {
    do {
        let results = try category.find().flatMap(Category.init)
        completion(results, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

// POST /projects
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

/*
 // GET /projects/:id
 private func getProject(name: String, completion: (Project?, RequestError?) -> Void) {
 do {
 guard let bson = try projects.findOne(["name": name]) else {
 return completion(nil, .notFound)
 }
 guard let project = Project(from: bson) else{
 return completion(nil, .internalServerError)
 }
 completion(project,nil)
 } catch {
 Log.error(error.localizedDescription)
 completion(nil, .internalServerError)
 }
 }
 
 // PUT /projects/:id
 private func updateProject(name: String, to project: Project, completion: (Project?, RequestError?) -> Void) {
 do {
 guard try projects.count(["name":name]) == 1 else {
 return completion(nil, .notFound)
 }
 try projects.update(["name":name], to: project.toBSON())
 completion(project, nil)
 } catch {
 Log.error(error.localizedDescription)
 completion(nil, .internalServerError)
 }
 
 }
 
 // DELETE /projects/:id
 private func deleteProject(name: String, completion: (RequestError?) -> Void){
 do {
 guard try projects.count(["name": name]) == 1 else {
 return completion(.notFound);
 }
 try projects.remove(["name": name])
 completion(nil)
 } catch {
 Log.error(error.localizedDescription)
 completion(.internalServerError)
 }
 }
 */



/*
 POST -> niet idemportent (POST, POST)
 PUT -> wel idempotent (PUT, PUT)
 PATCH -> wel idempotent
 */


