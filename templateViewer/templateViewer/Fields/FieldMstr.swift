//
//  Field.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 1/2/18.
//  Copyright © 2018 nems. All rights reserved.
//

import Foundation
import UIKit

enum FieldMstrError: Error {
    case couldNotCreateObject
    case couldNotGetCGRectSize
    case couldNotGetHeightFromJSON
    case couldNotGetWidthFromJSON
    case couldNotGetPosxFromJSON
    case couldNotGetPosyFromJSON
}

typealias fpKey = FieldProperties

class FieldMstr {

    var mstrField: fields?
    
    init?(json: json?) throws {
        guard let json = json, let jsonArray = json["fields"] as? parsableJSON else {
            throw FieldMstrError.couldNotCreateObject
        }
        self.mstrField = fields(buttons: [UIButton](), textFields: [UITextField](), radioButtons: [UIButton](), checkboxes: [UIButton](), activeText: [UILabel](), memoText: [UITextField](), notePad: [UITextField](), imageContainers: [UIImageView]())
        for item in jsonArray {
            composeObject(item: item)
        }
        
    }
    
    func addToView(view: UIView) {
        guard let buttons = self.mstrField?.buttons else {
            return
        }
        for button in buttons {
            view.addSubview(button)
        }
        
        guard let textFields = self.mstrField?.textFields else {
            return
        }
        
        for textField in textFields {
            view.addSubview(textField)
        }
        
        guard let checkboxes = self.mstrField?.checkboxes else {
            return
        }
        
        for checkbox in checkboxes {
            view.addSubview(checkbox)
        }
        
    }
    
    func composeObject(item: [String: Any]) {
        
        
        for (key, value) in item {
            if key == fpKey.displayAs && value as? String == "" {
                guard let fieldType = item[fpKey.fieldType] as? String else {
                    print("could not use as string")
                    break
                }
                switch fieldType {
                    case "Label", "label", "Text", "Date", "Numeric": do {
                            let rect = try createObject(item: item)
                            let textField = createTextFields(sizeAndPosition: rect)
                            textField.text = item[fpKey.fieldName] as? String
                            self.mstrField?.textFields.append(textField)
                        
                        } catch {
                            print(error)
                }
                case "button": do {
                    let rect = try createObject(item: item)
                    let button = createButtons(sizeAndPosition: rect)
                    button.titleLabel?.text = item[fpKey.fieldName] as? String
                    self.mstrField?.buttons.append(button)
                } catch {
                    print(error)
                    }
                default: print(fieldType); continue
                }
            } else if key == fpKey.displayAs && value as? String != "" {
                guard let svalue = value as? String else {
                    
                    break
                }
                switch svalue {
                case "RadioButton": do {
                    let rect = try createObject(item: item)
                    let radioButton = createRadioButtons(sizeAndPosition: rect)
                    self.mstrField?.radioButtons.append(radioButton)
                } catch {
                    print(error)
                    }
                case "CheckBox": do {
                    let rect = try createObject(item: item)
                    let checkBox = createButtons(sizeAndPosition: rect)
                    self.mstrField?.checkboxes.append(checkBox)
                } catch {
                    print(error)
                    }
                default: print(svalue)
                }
            }
            
        }
        
    }
    
}

func createObject(item: [String: Any]) throws -> CGRect {
    guard let height = item[fpKey.height] as? CGFloat else {
        throw FieldMstrError.couldNotGetHeightFromJSON
    }
    guard let width = item[fpKey.width] as? CGFloat else {
        throw FieldMstrError.couldNotGetWidthFromJSON
    }
    guard let posx = item[fpKey.posx] as? CGFloat else {
        throw FieldMstrError.couldNotGetPosxFromJSON
    }
    guard let posy = item[fpKey.posy] as? CGFloat else {
        throw FieldMstrError.couldNotGetPosyFromJSON
    }
    
    let rect = CGRect(x: posx, y: posy, width: width, height: height)
    return rect
}




func createButtons(sizeAndPosition: CGRect) -> UIButton {
    let button = UIButton(frame: sizeAndPosition)
    return button
}

func createLabels(sizeAndPosition: CGRect) -> UILabel {
    let label = UILabel(frame: sizeAndPosition)
    return label
}

func createRadioButtons(sizeAndPosition: CGRect)-> UIButton {
    let button = UIButton(frame: sizeAndPosition)
    return button
}

func createActiveTexts(label: UILabel) -> UILabel {
    label.isUserInteractionEnabled = true
    return label
}

func createTextFields(sizeAndPosition: CGRect) -> UITextField {
    let field = UITextField(frame: sizeAndPosition)
    return field
}

func createMemoBoxes(textField: UITextField) -> UITextField {
    return textField
}

func createNotePad(textField: UITextField) throws -> UITextField {
    throw FieldMstrError.couldNotCreateObject
}


struct fields {
    var buttons: [UIButton]
    var textFields: [UITextField]
    var radioButtons: [UIButton]
    var checkboxes: [UIButton]
    var activeText: [UILabel]
    var memoText: [UITextField]
    var notePad: [UITextField]
    var imageContainers: [UIImageView]
}
