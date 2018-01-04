//
//  JSONWrapper.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 1/2/18.
//  Copyright © 2018 nems. All rights reserved.
//

import Foundation

enum JSONWrapperError: Error {
    case badURL
    case noData
    case requestDenied
    case fileNotFound
    case connectionLost
    case dataCorrupted
    case requestFailed
}

enum FileSource {
    case local
    case external
}


/**
JSON wrapper object used to pull json files from either the local device or from url links.
 
 - Author:
 Scott Eremia-Roden
 
 
*/
class JSONWrapper {
    
    let url: URL
    let source: FileSource
    let data: Data?
    var jsonMessage: JSONMessage?
    
    init(url: URL, source: FileSource) {
        self.url = url
        self.source = source
        self.data = nil
    }
    
    convenience init?(urlPath: String, source: FileSource) throws {
        var uri: URL?
        if source == .external {
            uri = URL(string: urlPath)
        } else if source == .local {
            uri = Bundle.main.url(forResource: urlPath, withExtension: "json")
        }
        guard let url = uri else {
            throw JSONWrapperError.badURL
        }
        self.init(url: url, source: source)
    }
    
    func getJsonDataLocal(url: URL) throws -> (json?) {
        do {
            let someData = try Data(contentsOf: url, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: someData, options: []) as? json
            if json == nil {
                let jsonV2 = try JSONSerialization.jsonObject(with: someData, options: .allowFragments) as? [String: Any]
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
                return dict
                
                
            }
            return json
        } catch JSONWrapperError.dataCorrupted {
            print("data corrupted")
        } catch {
            print(error)
            return (nil)
        }
        return (nil)
    }
    
    func getJsonDataExternal(url: URL, completionHandler completion: @escaping (json?, JSONWrapperError?) -> Void ) -> json? {
        let jsonMessage = JSONMessage(configuration: .default)
        let json = jsonMessage.download(url: url) { data, error in
                completion(data, error)
            
        }
        
        return json
        
    }
    
    func getJSON(url: URL, completionHandler completion: @escaping (json?) -> Void) -> json? {
        if self.source == .local {
            do {
                let json = try getJsonDataLocal(url: url)
                completion(json)
                return json
            } catch {
                print(error)
                return nil
            }
        } else {
            let message = getJsonDataExternal(url: url) { (json, error) in
                completion(json)
                
                return
            }
            return message
        }
    }
}
