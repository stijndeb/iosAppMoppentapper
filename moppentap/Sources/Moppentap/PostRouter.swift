import Kitura
import KituraContracts
import LoggerAPI
import ExtendedJSON
import Foundation
import BSON
import Dispatch
import MongoKitten

private let posts = database["posts"]
private let category = database["categories"]
private let comment = database["comments"]
private let rating = database["ratings"]
private let users = database["users"]



func configurePostRouter(on router: Router){
    router.get("/", handler: getAllPosts)
    router.post("/", handler: addPost)
    //router.get("/", handler: getProject)
    //router.put("/", handler: updateProject)
    //router.delete("/", handler: deleteProject)
    
}

// Codable Routing API

// GET /projects
private func getAllPosts(completion: ([Post]?, RequestError?)  -> Void) {
    do {
        
        let auteurlookup = AggregationPipeline.Stage.lookup(from: "users", localField: "auteur",foreignField: "_id",as: "auteur")
        let ratinglookup = AggregationPipeline.Stage.lookup(from: "ratings", localField: "beoordeling",foreignField: "_id",as: "beoordeling")
        let categorylookup = AggregationPipeline.Stage.lookup(from: "categories", localField: "category",foreignField: "_id",as: "category")
        let commentlookup = AggregationPipeline.Stage.lookup(from: "comments", localField: "comments",foreignField: "_id",as: "comments")

        let profileProjection: Projection = ["_id", "datum", "auteur", "title", "category", "inhoud", "beoordeling", "comments"]
        
        let projectstage = AggregationPipeline.Stage.project(profileProjection)
        
        let pipeline: AggregationPipeline = [
        projectstage,
            auteurlookup, ratinglookup, categorylookup, commentlookup
        ]
        
        let iets = try posts.aggregate(pipeline).flatMap(Post.init)
        
        /*let results = try posts.find().flatMap(Post.init)
        let test = try posts.aggregate([
            .lookup{
                from: "items",
                localField: "item",    // field in the orders collection
                foreignField: "item",  // field in the items collection
                as: "fromItems"
            }
         
            ])*/
        completion(iets, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}




// POST /projects
private func addPost(post: Post, completion: (Post?, RequestError?) -> Void) {
    do {
        guard try posts.count(["title": post.title]) == 0 else{
            completion(nil, .conflict)
            return
        }
        try posts.insert(post.toBSON())
        completion(post, nil)
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


