//
//  TemplateFieldLayout.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 12/30/17.
//  Copyright © 2017 nems. All rights reserved.
//

import Foundation
import UIKit

enum TemplateLayoutError: Error {
    case noParsableJSON
    case couldNotLayoutCorrectly
    case unsupportedLayoutConstraints
    case noTextFields
    case noLabels
}

class TemplateFieldLayout {
    
    var jsonObjectManager: SimpleJSON?
    var jsonDictionary: parsableJSON?
    
    
    init(path: String, fileExtension: String, dataFromExternalPath: Bool) {
        self.jsonObjectManager = SimpleJSON(path: path, fileExtension: fileExtension, dataFromExternalPath: dataFromExternalPath)
    }
    
    
    /**
     Used to create the layout for view by parsing the JSON.
     
     - Author:
     Scott Eremia-Roden
     - Version:
     0.1
     
     
     */
    func createLayout(viewToLayout view: UIView, jsonMessage json: JSON?) throws -> UIView? {
        guard let json = json ?? jsonObjectManager?.json else {
            throw SimpleJSONerror.noJSON
        }
        
        do {
            guard let textFields = try createTextFieldsForView(jsonMessage: json) else {
                throw TemplateLayoutError.noTextFields
            }
            let buttons = try createButtonsForView(jsonMessage: json)
            guard let labels = try createLabelsView(jsonMessage: json) else {
                throw TemplateLayoutError.noLabels
            }
            
            for textField in textFields {
                view.addSubview(textField)
            }
            for label in labels {
                view.addSubview(label)
            }
            
            if let buttons = buttons {
                for button in buttons {
                    view.addSubview(button)
                }
            } else {
                return view
            }

            
        } catch TemplateLayoutError.noLabels {
            print(TemplateLayoutError.noLabels)
        } catch TemplateLayoutError.noTextFields {
            print(TemplateLayoutError.noTextFields)
        }
        
        
        // no json object to parse
       
        
        // with json object found we need to parse through it and find all the objects we need to create
        view.layoutSubviews()
        return view
        
    }
    /// function to create buttons for createLayout function
    private func createLabelsView(jsonMessage json: JSON) throws -> [UILabel]? {
        var arrayOfLabels = [UILabel]()
        
        do {
            self.jsonDictionary = try self.jsonObjectManager?.parseThroughJSON(json: json, parseKey: "fields")
            guard let dict = self.jsonDictionary else {
                print("no dictionary")
                return nil
            }
            for item in dict {
                if item["field_type"] as? String == "label" {
                    let someLabel = UILabel()
                    someLabel.text = item["field_name"] as? String
                    arrayOfLabels.append(someLabel)
                }
            }
        } catch {
            print(error)
            return nil
        }
        return arrayOfLabels
    }
    
    
    
    /// function to create buttons for createLayout function
    private func createButtonsForView(jsonMessage json: JSON) throws -> [UIButton]? {
        var arrayOfButtons = [UIButton]()
        
        do {
            self.jsonDictionary = try self.jsonObjectManager?.parseThroughJSON(json: json, parseKey: "fields")
            guard let dict = self.jsonDictionary else {
                print("no dictionary")
                return nil
            }
            for item in dict {
                if item["field_type"] as? String == "button" {
                    let someButton = UIButton()
                    someButton.titleLabel?.text = item["field_name"] as? String
                    arrayOfButtons.append(someButton)
                }
            }
        } catch {
            print(error)
            return nil
        }
        return arrayOfButtons
    }
    
    
    
    /// function to create textFields for createLayout function
    private func createTextFieldsForView(jsonMessage json: JSON) throws -> [UITextField]? {
        var arrayOfTextFields = [UITextField]()
    
        do {
           self.jsonDictionary = try self.jsonObjectManager?.parseThroughJSON(json: json, parseKey: "fields")
            guard let dict = self.jsonDictionary else {
                print("no dictionary")
                return nil
            }
            for item in dict {
                if item["field_type"] as? String == "text" {
                    let someField = UITextField()
                    someField.text = item["field_name"] as? String
                    arrayOfTextFields.append(someField)
                }
            }
        } catch {
            print(error)
            return nil
        }
        return arrayOfTextFields
    }
    
}
