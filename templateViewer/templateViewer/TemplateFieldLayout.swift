/*
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
    
    var jsonObjectManager: JSONWrapper?
    var jsonDictionary: parsableJSON?
    
    
    init(path: String, fileExtension: String, dataFromExternalPath: Bool) {
  
    }
    
    
    /**
     Used to create the layout for view by parsing the JSON.
     
     - Author:
     Scott Eremia-Roden
     - Version:
     0.1
     
     
     */
    func createLayout(viewToLayout view: UIView, jsonMessage json: JSON?, completionHandler completion: @escaping (UIView) -> Void ) throws -> UIView? {
        print(json)
        
        guard let json = self.jsonObjectManager?.json ?? json else {
            
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
                completion(view)
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
        dump(view.subviews)
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
                let someLabel = UILabel()
                if item["field_type"] as? String == "label" {
                    someLabel.text = item["field_name"] as? String
                    guard let posy = item["posy"] as? String else {
                        print("breaking from posy")
                        arrayOfLabels.append(someLabel)
                        break
                    }
                    guard let posx = item["posx"] as? String else {
                        print("breaking from posx")
                        arrayOfLabels.append(someLabel)
                        break
                    }
                    guard let width = item["width"] as? String else {
                        print("breaking from width")
                        arrayOfLabels.append(someLabel)
                        break
                    }
                    guard let height = item["height"] as? String else {
                        print("breaking from height")
                        arrayOfLabels.append(someLabel)
                        break
                    }
                    guard let posxInt = Int(posx) else {
                        print("couldn't make posx an int")
                        break
                    }
                    guard let posyInt = Int(posy) else {
                        print("couldn't make posy an int")
                        break
                    }
                    guard let widthInt = Int(width) else {
                        print("couldn't make width an int")
                        break
                    }
                    guard let heightInt = Int(height) else {
                        print("couldn't make height an int")
                        break
                    }
                    someLabel.frame = CGRect(x: posxInt, y: posyInt, width: widthInt, height: heightInt)
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
                    guard let posy = item["posy"] as? String else {
                        print("breaking from posy")
                        arrayOfButtons.append(someButton)
                        break
                    }
                    guard let posx = item["posx"] as? String else {
                        print("breaking from posx")
                        arrayOfButtons.append(someButton)
                        break
                    }
                    guard let width = item["width"] as? String else {
                        print("breaking from width")
                        arrayOfButtons.append(someButton)
                        break
                    }
                    guard let height = item["height"] as? String else {
                        print("breaking from height")
                        arrayOfButtons.append(someButton)
                        break
                    }
                    guard let posxInt = Int(posx) else {
                        print("couldn't make posx an int")
                        break
                    }
                    guard let posyInt = Int(posy) else {
                        print("couldn't make posy an int")
                        break
                    }
                    guard let widthInt = Int(width) else {
                        print("couldn't make width an int")
                        break
                    }
                    guard let heightInt = Int(height) else {
                        print("couldn't make height an int")
                        break
                    }
                    someButton.frame = CGRect(x: posxInt, y: posyInt, width: widthInt, height: heightInt)
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
                    guard let posy = item["posy"] as? String else {
                        print("breaking from posy")
                        arrayOfTextFields.append(someField)
                        break
                    }
                    guard let posx = item["posx"] as? String else {
                        print("breaking from posx")
                        arrayOfTextFields.append(someField)
                        break
                    }
                    guard let width = item["width"] as? String else {
                        print("breaking from width")
                        arrayOfTextFields.append(someField)
                        break
                    }
                    guard let height = item["height"] as? String else {
                        print("breaking from height")
                        arrayOfTextFields.append(someField)
                        break
                    }
                    guard let posxInt = Int(posx) else {
                        print("couldn't make posx an int")
                        break
                    }
                    guard let posyInt = Int(posy) else {
                        print("couldn't make posy an int")
                        break
                    }
                    guard let widthInt = Int(width) else {
                        print("couldn't make width an int")
                        break
                    }
                    guard let heightInt = Int(height) else {
                        print("couldn't make height an int")
                        break
                    }
                    someField.frame = CGRect(x: posxInt, y: posyInt, width: widthInt, height: heightInt)
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
 */
