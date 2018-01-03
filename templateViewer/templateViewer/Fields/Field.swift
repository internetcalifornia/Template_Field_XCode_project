//
//  Field.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 1/2/18.
//  Copyright © 2018 nems. All rights reserved.
//

import Foundation
import UIKit

class FieldMstr {
    
    var fields: [fieldType]
    
    init?(json: json?) {
        guard let json = json, let jsonArray = json["fields"] as? parsableJSON else {
            return nil
        }
        for item in jsonArray {
            if item["field_type"] as? String == "label" {
                print("create label")
            } else if item["field_type"] as? String == "button" {
                print("create button")
            } else if item["field_type"] as? String == "radio_button" {
                print("create button")
            } else if item["field_type"] as? String == "checkbox" {
                print("create button")
            } else if item["field_type"] as? String == "memo" {
                print("create button")
            } else if item["field_type"] as? String == "note" {
                print("create button")
            } else {
                print(json)
            }
        }
        
        return nil
    }
    
    
    
    
}

func createButtons(size: CGRect, posX: CGFloat, posY: CGFloat, parentView vc: UIView) -> [UIButton]? {
    return nil
}

func createLabels(size: CGRect, posX: CGFloat, posY: CGFloat, parentView vc: UIView) -> [UILabel]? {
    return nil
}

func createRadioButtons(size: CGRect, posX: CGFloat, posY: CGFloat, parentView vc: UIView) -> [UIButton]? {
    return nil
}

func createActiveTexts(label: UILabel) -> [UILabel]? {
    return nil
}

func createTextFields(size: CGRect, posX: CGFloat, posY: CGFloat, parentView vc: UIView) -> [UITextField]? {
    return nil
}

func createMemoBoxes(textField: UITextField) -> [UITextField]? {
    return nil
}

func createNotePad(textField: UITextField) -> [UITextField]? {
    return nil
}

enum fieldType {
    case button(type: UIButton)
    case radioButton(type: UISegmentedControl)
    case checkbox(type: UIButton)
    case textField(type: UITextField)
    case activeText(type: UILabel)
    case memoBox(type: UITextField)
    case notePad(type: UITextField)
}
