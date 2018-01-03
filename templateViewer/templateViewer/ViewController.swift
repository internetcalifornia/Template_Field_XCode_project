//
//  ViewController.swift
//  templateViewer
//
//  Created by Scott Eremia-Roden on 12/30/17.
//  Copyright © 2017 nems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //var template: TemplateFieldLayout?
    var templateName: String?

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        do {
            let jsonMessage = try JSONWrapper(urlPath: "dv", source: .local)
            
            guard let jMessage = jsonMessage, let url = jsonMessage?.url else {
                print("no jsonwrapper")
                return
            }
            let data = jMessage.getJSON(url: url)
            let fieldMstr = FieldMstr(json: data)
        } catch {
            print(error)
        }
        
    }

}

