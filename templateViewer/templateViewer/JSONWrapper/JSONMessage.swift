//
//  JSONDownlaoder.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 1/2/18.
//  Copyright © 2018 nems. All rights reserved.
//

import Foundation

final class JSONMessage {
    
    var jsonData: json?
    
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: .default)
    }
    
    func download(url: URL, completionHandler completion: @escaping (json?, JSONWrapperError?) -> Void) -> json? {
        let urlRequest = URLRequest(url: url)
        var json: json?
        
        let task = self.task(with: urlRequest, completionHandler: {(data, error) in
            DispatchQueue.main.async {
                json = data
                completion(data, error)
            }
        })
        task.resume()

        return json
    }
    
    func task(with request: URLRequest, completionHandler completion: @escaping (json?, JSONWrapperError?) -> Void) -> URLSessionDataTask {
        let task = self.session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? json
                        self.jsonData = json
                        completion(json, nil)
                        if json == nil {
                            let jsonV2 = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                            //print(jsonV2?["fields"] as? [[String: Any]])
                            guard let header = jsonV2?["fields"] as? [[String: Any]] else {
                                throw JSONWrapperError.dataCorrupted
                            }
                            //print("printing header: \(header)")
                            var dict = [String: [Any]]()
                            for item in header {
                                if dict["fields"] == nil {
                                    dict.updateValue([item], forKey: "fields")
                                } else {
                                    dict["fields"]?.append(item as Any)
                                }
                            }
                            self.jsonData = dict
                            completion(dict, nil)
                            
                            
                        }
                    } catch {
                        print(JSONWrapperError.noData)
                        completion(nil, .noData)
                    }
                } else {
                    
                    print(JSONWrapperError.fileNotFound)
                    completion(nil, .fileNotFound)
                }
            } else if (httpResponse.statusCode >= 400 && httpResponse.statusCode < 500) {
                print(JSONWrapperError.requestDenied)
                completion(nil, .requestDenied)
            } else {
                print(JSONWrapperError.badURL)
                completion(nil, .badURL)
            }
        }
        
        return task
    }
    
}
