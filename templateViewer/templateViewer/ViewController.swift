//
//  ViewController.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 12/30/17.
//  Copyright © 2017 nems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var template: TemplateFieldLayout?
    var templateName: String?

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.templateName = "templateFields"
        self.template = TemplateFieldLayout(path: templateName!, fileExtension: "json", dataFromExternalPath: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
       
            do {
                try self.template?.createLayout(viewToLayout: self.view, jsonMessage: nil) { [unowned self] (caputredView) in
                    self.view = caputredView
                    self.view.layoutSubviews()
                    dump(self.view.subviews)
                }
            } catch {
                print("create layout \(error)")
            }
        
    }

}

