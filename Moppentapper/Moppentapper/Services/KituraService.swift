import Foundation
import KituraKit
import BCryptSwift

class KituraService {
    private init() {}
    static let shared = KituraService()
    
    private let client = KituraKit(baseURL: "http://localhost:8080/api/")!
    
    func getPosts(completion: @escaping ([Post]?) -> Void) {
        client.get("posts") {
            (posts: [Post]?, error: RequestError?) in
            if let error = error {
                print("Error while loading posts: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(posts)
            }
        }
    }
    
    func getDetailPost(withId id: String, respondWith: @escaping (Post?) -> Void){
        client.get("posts", identifier: id) {
            (post: Post?, error: RequestError?) in
            if let error = error {
                print("err while loading post: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                respondWith(post)
            }
        }
    }
    
    func getMyPosts(withName name: String, completion: @escaping ([Post]?) -> Void) {
        client.get("posts/myPosts", identifier: name) {
            (posts: [Post]?, error: RequestError?) in
            if let error = error {
                print("Error while loading posts: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(posts)
            }
        }
    }
    
    func login(username:String, password: String, respondWith: @escaping (User) -> Void) -> Void{
        let user = User(name: "", email: "", username: username, password: password)
        
        client.get("users/login", identifier: user.username) {
            (result: User?, error: RequestError?) in
            if let error = error {
                print("error while getting user : \(error.localizedDescription)")
                respondWith(user)
            }
            
            
            
            if let compare = BCryptSwift.verifyPassword(password, matchesHash: (result?.password)!) {
                if compare {
                    user.name = (result?.name)!
                    user.email = (result?.email)!
                    user.password = (result?.password)!
                    respondWith(user)
                }else{
                    respondWith(user)
                }
            }else {
                respondWith(user)
            }
            
            
            DispatchQueue.main.async {
                respondWith(user)
            }
        }
    }
    
    
    func ratePost(beoordeling: Rating, respondWith: @escaping (Post?) -> Void) -> Void{
        client.post("posts/ratePost", data: beoordeling){
            (post: Post?, error: RequestError?) in
            if let error = error {
                print("err while loading post: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                respondWith(post)
            }
        }
    }
    
    func addComment(comment: Comment, respondWith: @escaping (Post?) -> Void) -> Void{
        client.post("posts/addComment", data: comment){
            (post: Post?, error: RequestError?) in
            if let error = error {
                print("err while loading post: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                respondWith(post)
            }
        }
    }
    
    
    
    
}


