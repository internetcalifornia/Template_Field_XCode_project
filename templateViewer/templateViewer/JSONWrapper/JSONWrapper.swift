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
    /**
     sioemtopai
 
 
 */
    let url: URL
    let source: FileSource
    let data: Data?
    var jsonMessage: JSONMessage?
    
    init(url: URL, source: FileSource) {
        self.url = url
        self.source = source
        self.data = nil
    }
    
    convenience init?(urlPath: String, source: FileSource) {
        var uri: URL?
        if source == .external {
            uri = URL(string: urlPath)
        } else if source == .local {
            uri = Bundle.main.url(forResource: urlPath, withExtension: "json")
        }
        guard let url = uri else {
            return nil
        }
        self.init(url: url, source: source)
    }
    
    func getJsonDataLocal(url: URL) -> json? {
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? json
            return json
        } catch {
            print(error)
            return nil
        }
    }
    
    func getJsonDataExternal(url: URL) -> json? {
        let jsonMessage = JSONMessage(configuration: .default)
        return jsonMessage.download(url: url) { data, error in
                print("data: \(data)")
                print("Error: \(error)")
        }
    }
    
    func getJSON(url: URL) -> json? {
        if self.source == .local {
           return getJsonDataLocal(url: url)
        } else {
           return getJsonDataExternal(url: url)
        }
    }
}
