import Foundation
import KituraKit

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
    
    
}


