//
//  File.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 12/30/17.
//  Copyright © 2017 nems. All rights reserved.
//

import Foundation

enum SimpleJSONerror: Error {
    case couldNotGetLocalPath
    case keyNotParsable
    case noJSON
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
        do {
            let url = try SimpleJSON.retriveURL(path: path, fileExtension: fileExtension, dataFromExternalPath: dataFromExternalPath)
            self.init(path: url)
            self.getJSONData()
        } catch {
            print(error)
            return nil
        }
    }
    
    class func retriveURL(path: String, fileExtension: String? ,dataFromExternalPath: Bool) throws -> URL {
        if (dataFromExternalPath) {
            return URL(fileURLWithPath: path)
        } else {
            guard let localPath = Bundle.main.path(forResource: path, ofType: fileExtension) else {
                throw SimpleJSONerror.couldNotGetLocalPath
            }
            return URL(fileURLWithPath: localPath)
        }
    }
    
    private func getJSONData() {
        do {
            self.jsonData = try Data(contentsOf: self.path, options: .mappedIfSafe)
            guard let data = jsonData else {return print("no data")}
            let tempJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            self.json = tempJSON as? JSON
        } catch {
            print(error)
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
