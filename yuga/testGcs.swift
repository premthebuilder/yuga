import Foundation

let headers = [
    "content-md5": "7Qdih1MuhjZehB6Sv8UNjA==",
    "content-type": "text/plain",
    "cache-control": "no-cache",
    "postman-token": "63124202-765e-823b-0287-0b7a5101e024"
]

let postData = NSData(data: "Hello World!".data(using: String.Encoding.utf8)!)

let request = NSMutableURLRequest(url: NSURL(string: "https://storage.googleapis.com/yuga-171020.appspot.com/swift.txt?GoogleAccessId=storageadmin%40yuga-171020.iam.gserviceaccount.com&Expires=1503755879&Signature=tlcHVRwbvMSxaIB6oO%2FTDXRDczXGFSE6ZXHmZbtCUMhjpos36%2F1KdKV7Lbmm7XtKsq42SFNksUIZLplyAMpkG8aMBuydeoJd%20kvebLxK2k%20AX8Xr2VVf5Aq%2FvVJrPGGYGD0iEN%20bY264NIFbyJnlm0pthCVGtB5YqZJadCFDwPFWqi04312Jzzen1CXDY%20saY0BabmXaZeCzINz7kV%20aq0AJoS8taW0uqboYc1o4gCA6OPAswMr1E840a%20II4HqkeOWcv7PiHEPdw%2FsgH3PR%20TkGmjTAd9f8H6zJIFaT8DLbtsl7t3iAUM7Fvdtc9pGQt6KT0qUm9z3XfPEjP8OsTA%3D%3D")! as URL,
                                  cachePolicy: .useProtocolCachePolicy,
                                  timeoutInterval: 10.0)
request.httpMethod = "PUT"
request.allHTTPHeaderFields = headers
request.httpBody = postData as Data

let session = URLSession.shared
let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    if (error != nil) {
        print(error)
    } else {
        let httpResponse = response as? HTTPURLResponse
        print(httpResponse)
    }
})

dataTask.resume()
