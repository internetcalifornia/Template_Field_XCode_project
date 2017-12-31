//
//  File.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 12/30/17.
//  Copyright © 2017 nems. All rights reserved.
//

import Foundation

enum FileSource {
    case `internal`
    case `external`
}


enum SimpleJSONerror: Error {
    case couldNotGetLocalPath
    case keyNotParsable
    case noJSON
    case invalidStatusCode(statusCode: Int)
}


typealias JSON = [String: Any]
typealias parsableJSON = [[String: Any]]

class SimpleJSON {
    
    let path: URL
    var jsonData: Data?
    var json: JSON?
    var dict: parsableJSON?
    
    init?(path: URL) {
        self.path = path
    }
    
    
    
    convenience init?(path: String, fileExtension: String?, dataFromExternalPath: Bool) {
        let source: FileSource
        if (dataFromExternalPath) {
            source = .external
        } else {
            source = .internal
        }
        do {
            let result = try SimpleJSON.retriveURL(path: path, fileExtension: fileExtension, dataFromExternalPath: dataFromExternalPath)
            self.init(path: result.url)
            self.getJSONData(source: source) { [unowned self] (json, error) in
                self.json = json
            }
        } catch {
            print("catching this \(error)")
            return nil
        }
    }
    
    class func retriveURL(path: String, fileExtension: String? ,dataFromExternalPath: Bool) throws -> (url: URL, source: FileSource)  {
        if (dataFromExternalPath) {
            guard let url = URL(string: path) else {
                print("error")
                throw SimpleJSONerror.couldNotGetLocalPath
            }
            return (url, .external)
        } else {
            guard let localPath = Bundle.main.path(forResource: path, ofType: fileExtension) else {
                throw SimpleJSONerror.couldNotGetLocalPath
            }
            let url = URL(fileURLWithPath: localPath)
            return (url, .internal)
        }
    }
    
    private func getJSONData(source: FileSource, completionHandler completion: @escaping (JSON?, SimpleJSONerror?) -> () ) {
        do {
            if source == .external {
                
                let uriRequest = URLRequest(url: self.path)
                let session = URLSession(configuration: .default)

                DispatchQueue.main.async {
                    session.dataTask(with: uriRequest, completionHandler: { (data, response, error) in
                        guard let response = response as? HTTPURLResponse else {
                            completion(nil, SimpleJSONerror.invalidStatusCode(statusCode: 0))
                            return
                        }
                        if response.statusCode == 200 {
                            if let data = data {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON
                                    completion(json, nil)
                                } catch {
                                    completion(nil, SimpleJSONerror.noJSON)
                                    print("no json \(error)")
                                }
                        
                            } else {
                                completion(nil, SimpleJSONerror.invalidStatusCode(statusCode: response.statusCode))
                                return
                            }
                        }
                    }).resume()
                    
                }
                
            } else {
                self.jsonData = try Data(contentsOf: self.path, options: .mappedIfSafe)
                guard let data = jsonData else {
                    return print("no data")
                }
                let tempJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON
                completion(tempJSON, nil)
            }
            
        } catch {
            print("catching \(error)")
        }
    }
    
    public func parseThroughJSON(json: JSON, parseKey key: String) throws -> parsableJSON {
        var dictionary = parsableJSON.init()
        guard let formattedJSON = json[key] as? parsableJSON else {
            throw SimpleJSONerror.keyNotParsable
        }
        for item in formattedJSON {
            dictionary.append(item)

        }
        
        return dictionary
    }

    
}
