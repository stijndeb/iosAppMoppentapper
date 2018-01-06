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
    router.get("/", handler: getDetailPost)
    router.get("/myPosts", handler: getMyPosts)
    router.post("/ratePost", handler: ratePost)
    router.post("/addComment", handler: addComment)
}


private func getAllPosts(completion: ([Post]?, RequestError?)  -> Void) {
    do {
        //Om alle posts op te halen moeten ze elk apart opgevuld worden
        //hiermee bedoel ik de ObjectIds in elke post, opvullen met het corresponderende model
        //BVB: model van post:
        /*
         {
         "_id": {"$oid": "5a2a1b2438d291001403830a"},
         "title": "Twee Belgen werken samen op een vliegveld",
         "inhoud": "Twee Belgen werken samen op een vliegveld. ...",
         "auteur": {"$oid": "5a2a1ab538d2910014038309"},
         "category": {"$oid": "5a2859b2c56b110014d572ca"},
         "datum": {"$date": "2017-12-08T04:55:00.884Z"},
         "comments": [{"$oid": "5a2a1b8138d291001403830d"},{"$oid": "5a4a259af96a5d0014ea487f"},{"$oid": "5a4a9dfb1318bf0014ef6947"}],
         "beoordeling": [{"$oid": "5a2a1b4a38d291001403830b"},{"$oid": "5a2a1b7238d291001403830c"},{"$oid": "5a2d35b22237130014c0ed73"}],
         }
         */
        //id van auteur word dan vervangen door het object zelf
        //omdat we alle posts geven, willen we natuurlijk niet te veel nutteloze data, daarom word enkel de username en email van de auteur meegegeven
        //De comments worden leeg meegegeven, want die zijn niet nodig momenteel.
        
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
            auteurlookup, ratinglookup, categorylookup,
            commentlookup,
            auteurstage
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
        //Om alles van een post op te halen moeten we weer eerst de id's opvullen
        //Nu worden ook de comments mee gegeven
        //Dit moet op een speciale manier gebeuren als we ook de auteurs van elke comment willen hebben
        //via .unwind("$comments)" kunnen we dit doen.
        //ook hier enkel username en email van de comments meegeven.
        //daarna moeten we alles weer groeperen om zo de volledige post terug te geven.
        
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
        var pipeline: AggregationPipeline = [
            detailprojectstage, match,
            auteurlookup, ratinglookup, categorylookup, commentlookup, .unwind("$comments"), auteurstage, commentauteurlookup, comauteurstage, .group(groupDocument: doc)
        ]
        
        
        if try comment.count(["post": ObjectId(id)]) == 0 {
            pipeline = [detailprojectstage, match,
                        auteurlookup, ratinglookup, categorylookup, commentlookup]
        }
        
        guard let result = try posts.aggregate(pipeline).flatMap(Post.init).first else{
            return completion(nil, .notFound)
        }
        
        completion(result,nil)
        
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}


private func getMyPosts(name: String, completion: ([Post]?, RequestError?)  -> Void) {
    do {
        //get My posts is bijna hetzelfde als getalleposts
        //met als uitzondering dat hier de auteur van de post gelijk is aan de identifier
        
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

//geef beoordeling aan post
private func ratePost(data: Beoordeling, completion: (Post?, RequestError?) -> Void) {
    do {
        
        /* om een post te beoordelen, kijken we eerst of de post en de auteur bestaan
         *  daarna wordt het Rating model gemaakt met de juiste data en de juiste ObjectIds
         *  er wordt voor de rating een speciaal uniek ObjectId gemaakt
         *  en dan wordt het in de databank gestoken
         *
         *
         */
        guard try posts.count(["_id" : ObjectId(data.post)]) == 1 else {
            completion(nil, .notFound)
            return
        }
        
        guard try users.count(["username" : data.auteur]) == 1 else {
            completion(nil, .notFound)
            return
        }
        
        let user = try users.findOne(["username": data.auteur]).flatMap(User.init)
        let userId = (user?.id)!
        
        let deRating = Rating(auteur: userId, post: data.post, beoordeling: data.beoordeling, datum: data.datum)
        deRating.id = try ObjectId(deRating.objectId())
        try rating.insert(deRating.toBSON())
        
        
        
        
        /*
         *  om ook de rating bij de lijst van beoordelingen in de post te vullen hebben we eerst natuurlijk de volledige post zelf nodig
         *
         */
        
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
        
        let match = try AggregationPipeline.Stage.match("_id" == ObjectId(data.post))
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
        var pipeline: AggregationPipeline = [
            detailprojectstage, match,
            auteurlookup, ratinglookup, categorylookup, commentlookup, .unwind("$comments"), auteurstage, commentauteurlookup, comauteurstage, .group(groupDocument: doc)
        ]
        if try comment.count(["post": ObjectId(data.post)]) == 0 {
            pipeline = [detailprojectstage, match,
                        auteurlookup, ratinglookup, categorylookup, commentlookup]
        }
        
        guard let result = try posts.aggregate(pipeline).flatMap(Post.init).first else{
            return completion(nil, .notFound)
        }
        
        //de beoordeling in de post zelf steken
        result.beoordeling.append(deRating)
        try posts.update(["_id": result.id], to: result.toBSON())
        
        //de post terug sturen
        completion(result, nil)
        
        
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

private func addComment(data: Commentaar, completion: (Post?, RequestError?) -> Void) {
    do {
        
        /* om een post te beoordelen, kijken we eerst of de post en de auteur bestaan
         *  daarna wordt het Rating model gemaakt met de juiste data en de juiste ObjectIds
         *  er wordt voor de rating een speciaal uniek ObjectId gemaakt
         *  en dan wordt het in de databank gestoken
         *
         *
         */
        guard try posts.count(["_id" : ObjectId(data.post)]) == 1 else {
            completion(nil, .notFound)
            return
        }
        
        guard try users.count(["username" : data.auteur]) == 1 else {
            completion(nil, .notFound)
            return
        }
        
        let user = try users.findOne(["username": data.auteur]).flatMap(User.init)
        
        
        
        //let deRating = Rating(auteur: userId, post: data.post, beoordeling: data.beoordeling, datum: data.datum)
        //deRating.id = try ObjectId(deRating.objectId())
        //try rating.insert(deRating.toBSON())
        
        
        
        
        /*
         *  om ook de rating bij de lijst van beoordelingen in de post te vullen hebben we eerst natuurlijk de volledige post zelf nodig
         *
         */
        
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
        
        let match = try AggregationPipeline.Stage.match("_id" == ObjectId(data.post))
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
        var pipeline: AggregationPipeline = [
            detailprojectstage, match,
            auteurlookup, ratinglookup, categorylookup, commentlookup, .unwind("$comments"), auteurstage, commentauteurlookup, comauteurstage, .group(groupDocument: doc)
        ]
        if try comment.count(["post": ObjectId(data.post)]) == 0 {
            pipeline = [detailprojectstage, match,
                        auteurlookup, ratinglookup, categorylookup, commentlookup]
        }
        
        guard let result = try posts.aggregate(pipeline).flatMap(Post.init).first else{
            return completion(nil, .notFound)
        }
        
        let deComment = try Comment(inhoud: data.inhoud, auteur: user!, post: ObjectId(data.post), beoordeling: data.beoordeling, datum: data.datum)
        
        deComment.id = try ObjectId(deComment.objectId())
        try comment.insert(deComment.toBSON())
        
        
        
        //de comment in de post zelf steken
        result.comments.append(deComment)
        try posts.update(["_id": result.id], to: result.toBSON())
        completion(result, nil)
        
        
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}



