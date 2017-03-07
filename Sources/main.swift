
import Foundation
//import Kitura
//import KituraNet
//import SwiftyJSON
import SWSQLite

let version = 0.00

// get the path of the executable as all files are defined from here
let executablePath = FileManager.default.currentDirectoryPath
let settingsFilePath = executablePath + "/settings.json"
let dataPath = executablePath + "/shards/"

// load the settings file and create a global r/o object
let nodeSettings = Settings(path: settingsFilePath)

print("Scale v\(version) Started on TCP port \(nodeSettings.queryPort!)")

// create a router
//let router = Router()

srand48(1024)

//// setup a default response for anyone hitting the port
//router.route("/").get("/") {
//    (request: RouterRequest, response: RouterResponse, next) in
//    
//        response.send("SharkScale Database Engine v\(version)\n")
//        response.send("random seed:\(drand48())")
//        next()
//    
//}
//
//router.route("/").post {
//    (request: RouterRequest,  response: RouterResponse, next) in
//
//    let body = try request.readString() ?? ""
//    let requestDictionary = JSON(data: body.data(using: .utf8, allowLossyConversion: false)!)
//    
//    // check security
//    
//    // extract the payload
//    let payload = requestDictionary["payload"].dictionaryValue
//    let method = requestDictionary["method"].stringValue
//    
//    //let returnDictionary = BaseRequest.HandleRequest(request: request)
//    try response.send("Hello \(requestDictionary["id"].intValue)").end()
//    
//    next()
//}

// create the "system" shard/database
let Shards = ShardCoordinator()
let test = Shards.getShard(keyspace: "bob", partition: "squib")

// Add an HTTP server and connect it to the router
//Kitura.addHTTPServer(onPort: nodeSettings.queryPort!, with: router)

// Start the Kitura runloop (this call never returns)
//Kitura.run()
