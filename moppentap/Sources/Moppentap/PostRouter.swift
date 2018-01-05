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
    //router.post("/", handler: addPost)
    router.get("/", handler: getDetailPost)
    router.get("/myPosts", handler: getMyPosts)
    //router.put("/", handler: updateProject)
    //router.delete("/", handler: deleteProject)
    
}

// Codable Routing API

// GET /projects
private func getAllPosts(completion: ([Post]?, RequestError?)  -> Void) {
    do {
        
        let auteurproject: Projection = ["auteur.name": .excluded,"auteur.password": .excluded]
        let auteurstage = AggregationPipeline.Stage.project(auteurproject)
        
        let auteurlookup = AggregationPipeline.Stage.lookup(from: "users", localField: "auteur",foreignField: "_id",as: "auteur")
        let ratinglookup = AggregationPipeline.Stage.lookup(from: "ratings", localField: "beoordeling",foreignField: "_id",as: "beoordeling")
        let categorylookup = AggregationPipeline.Stage.lookup(from: "categories", localField: "category",foreignField: "_id",as: "category")
        let commentlookup = AggregationPipeline.Stage.lookup(from: "comments", localField: "comments",foreignField: "_id",as: "comments")

        let profileProjection: Projection = [
            "_id": .included,
            "datum": .included,
            "auteur": .included,
            "title": .included,
            "category": .included,
            "inhoud": .included,
            "beoordeling": .included,
            "comments": "[]"]
 
        let projectstage = AggregationPipeline.Stage.project(profileProjection)
        let pipeline: AggregationPipeline = [
        projectstage,
            auteurlookup, ratinglookup, categorylookup, commentlookup, auteurstage
        ]
        
        let result = try posts.aggregate(pipeline).flatMap(Post.init)
  
        completion(result, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}


private func getDetailPost(id: String, completion: (Post?, RequestError?) -> Void){
    do {
        let match = try AggregationPipeline.Stage.match("_id" == ObjectId(id))
        
        let auteurproject: Projection = ["auteur.name": .excluded,"auteur.password": .excluded]
        let auteurstage = AggregationPipeline.Stage.project(auteurproject)
        
        let doc: Document = ["_id": "$_id",
                             "datum": ["$first": "$datum"],
                             "auteur": ["$first": "$auteur"],
                             "title": ["$first": "$title"],
                             "category": ["$first": "$category"],
                             "inhoud": ["$first": "$inhoud"],
                             "beoordeling": ["$first": "$beoordeling"],
                             "comments": ["$push": "$comments"]]
        let auteurlookup = AggregationPipeline.Stage.lookup(from: "users", localField: "auteur",foreignField: "_id",as: "auteur")
        let ratinglookup = AggregationPipeline.Stage.lookup(from: "ratings", localField: "beoordeling",foreignField: "_id",as: "beoordeling")
        let categorylookup = AggregationPipeline.Stage.lookup(from: "categories", localField: "category",foreignField: "_id",as: "category")
        let commentlookup = AggregationPipeline.Stage.lookup(from: "comments", localField: "comments",foreignField: "_id",as: "comments")
        
        let commentauteurlookup = AggregationPipeline.Stage.lookup(from: "users", localField: "comments.auteur", foreignField: "_id", as: "comments.auteur")
        
        let comauteurproject: Projection = ["comments.auteur.name": .excluded,"comments.auteur.password": .excluded]
        let comauteurstage = AggregationPipeline.Stage.project(comauteurproject)
        
        let detailProjection: Projection = [
            "_id": .included,
            "datum": .included,
            "auteur": .included,
            "title": .included,
            "category": .included,
            "inhoud": .included,
            "beoordeling": .included,
            "comments": .included]
        
        let detailprojectstage = AggregationPipeline.Stage.project(detailProjection)
        let pipeline: AggregationPipeline = [
            detailprojectstage, match,
            auteurlookup, ratinglookup, categorylookup, commentlookup, .unwind("$comments"), auteurstage, commentauteurlookup, comauteurstage, .group(groupDocument: doc)
        ]
        
        guard let result = try posts.aggregate(pipeline).flatMap(Post.init).first else{
            return completion(nil, .notFound)
        }
        
        completion(result,nil)
        
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


private func getMyPosts(name: String, completion: ([Post]?, RequestError?)  -> Void) {
    do {
        
        guard try users.count(["username" : name]) == 1 else {
            completion(nil, .notFound)
            return
        }
        
        let match = try AggregationPipeline.Stage.match("auteur.username" == name)
        
        let auteurproject: Projection = ["auteur.name": .excluded,"auteur.password": .excluded]
        let auteurstage = AggregationPipeline.Stage.project(auteurproject)
        
        let auteurlookup = AggregationPipeline.Stage.lookup(from: "users", localField: "auteur",foreignField: "_id",as: "auteur")
        let ratinglookup = AggregationPipeline.Stage.lookup(from: "ratings", localField: "beoordeling",foreignField: "_id",as: "beoordeling")
        let categorylookup = AggregationPipeline.Stage.lookup(from: "categories", localField: "category",foreignField: "_id",as: "category")
        let commentlookup = AggregationPipeline.Stage.lookup(from: "comments", localField: "comments",foreignField: "_id",as: "comments")
        
        let profileProjection: Projection = [
            "_id": .included,
            "datum": .included,
            "auteur": .included,
            "title": .included,
            "category": .included,
            "inhoud": .included,
            "beoordeling": .included,
            "comments": "[]"]
        
        let projectstage = AggregationPipeline.Stage.project(profileProjection)
        let pipeline: AggregationPipeline = [
            projectstage,
            auteurlookup, ratinglookup, categorylookup, commentlookup, auteurstage, match
        ]
        
        let result = try posts.aggregate(pipeline).flatMap(Post.init)
        
        completion(result, nil)
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


