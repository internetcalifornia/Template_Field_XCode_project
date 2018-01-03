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
    
    typealias key = FieldProperties

    var fields: [fields]
    
    init?(json: json?) {
        guard let json = json, let jsonArray = json["fields"] as? parsableJSON else {
            return nil
        }
        
        
        
        for item in jsonArray {
            var height: CGFloat
            var width: CGFloat
            var posx: CGFloat
            var posy: CGFloat
            
            
            if item[key.displayAs] as? String == "label" && item[key.displayAs] as? String == "" {

            } else if item[key.displayAs] as? String == "button" {
                print("create button")
            } else if item[key.displayAs] as? String == "RadioButton" {
                print("create radio button")
            } else if item[key.displayAs] as? String == "CheckBox" {
                print("create checkbox")
            } else if item[key.fieldType] as? String == "memo" {
                print("create memo")
            } else if item[key.fieldType] as? String == "note" {
                print("create note")
            } else if item[key.fieldType] as? String == "Text" {
                print("create field")
            } else if (item[key.fieldType] as? String == "Numeric" && item[key.displayAs] as? String == "") {
                print("create numeric field")
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
