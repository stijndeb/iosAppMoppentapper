import Kitura
import KituraContracts
import LoggerAPI
import ExtendedJSON

private let posts = database["posts"]
private let category = database["categories"]
private let comment = database["comments"]
private let rating = database["ratings"]
private let users = database["users"]



func configureUserRouter(on router: Router){
    router.get("/login", handler: login)
    //router.post("/register", handler: register)
    
}

//enkel de login methode wordt gebruikt.
private func login(identifier: String, completion: (User?, RequestError?) -> Void) {
    do {
        guard try users.count(["username": identifier]) == 1 else{
            completion(nil, .notFound)
            return
        }
        let result = try users.findOne(["username": identifier]).flatMap(User.init)
        completion(result!, nil)
        
            
    }catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

//
/*
private func register(user: User, completion: (User?, RequestError?) -> Void) {
    do {
        guard try users.count(["username": user.username]) == 0 else{
            completion(nil, .conflict)
            return
        }
        try users.insert(user.toBSON())
        completion(user, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}
*/


