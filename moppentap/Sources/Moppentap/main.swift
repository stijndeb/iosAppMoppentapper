import Foundation
import HeliumLogger
import Kitura
import KituraStencil
import MongoKitten

HeliumLogger.use()

let database = try! Database("mongodb://Stijn:Stijn@ds129156.mlab.com:29156/moppentapper")
//let database = try MongoKitten.Database("mongodb://127.0.0.1:27017/mopjes")

let router = Router()
configurePostRouter(on: router.route("/api/posts"))
configureUserRouter(on: router.route("/api/users"))
configureCategoryRouter(on: router.route("/api/category"))



Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()

