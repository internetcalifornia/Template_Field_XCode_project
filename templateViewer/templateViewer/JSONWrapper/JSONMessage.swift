//
//  JSONDownlaoder.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 1/2/18.
//  Copyright © 2018 nems. All rights reserved.
//

import Foundation

final class JSONMessage {
    
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
                        completion(json, nil)
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
