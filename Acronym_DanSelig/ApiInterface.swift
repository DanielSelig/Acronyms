//
//  ApiInterface.swift

import Foundation

final class ApiInterface: NSObject, URLSessionDelegate
{
    var request:URLRequest?
    
    init(apiParams: ApiParams, args:String)
    {
        let urlString = "\(apiParams.scheme)://\(apiParams.host)/\(apiParams.path)?\(args)"
        let url = URL(string: urlString)
        
        request = URLRequest(url:url!)
    }
    
    func get(_ completion: @escaping ([[String:AnyObject]]?, Error?) -> Void)
    {
        request?.httpMethod = "GET"
        talk(completion)
    }
    
    fileprivate func talk (_ completion: @escaping ([[String:AnyObject]]?, Error?) -> Void)
    {
        let sessionConfiguration: URLSessionConfiguration = .default
        let session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request!, completionHandler: {
                (data, response, error) -> Void in
                if error != nil
                {
                    completion(nil, error)
                }
                else
                {
                    let responseDict = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! [[String:AnyObject]]
                    DispatchQueue.main.async {
                        completion(responseDict, nil)
                    }
                }
            })            

        task.resume()
    }
    
}
