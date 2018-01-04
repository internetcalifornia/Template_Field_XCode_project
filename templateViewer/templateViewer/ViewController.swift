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
    var fieldMstr: FieldMstr?
    
    @IBOutlet weak var scrollView: UIScrollView!
    

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
            var lateData: json? {
                didSet {
                    do {
                    fieldMstr = try FieldMstr(json: lateData)
                        scrollView.frame = UIScreen.main.bounds
                        fieldMstr?.addToView(view: scrollView)
                        var maxY: CGFloat = 0
                        var maxX: CGFloat = 0
                        for view in scrollView.subviews {
                            if maxY <= view.frame.maxY {
                                maxY = view.frame.maxY
                            }
                            if maxX <= view.frame.maxX {
                                maxX = view.frame.maxX
                            }
                        }
                        if maxY > scrollView.frame.maxY {
                            scrollView.contentSize.height = maxY
                        }
                        if maxX > scrollView.frame.maxX {
                            scrollView.contentSize.width = maxX
                        }
                    } catch {
                        print(error)
                    }
                } willSet {
                    print("will set")
                }
            }
            let data = jMessage.getJSON(url: url) { (json) in
                lateData = json
            }
            
            
            
            
            
        } catch {
            print(error)
        }
        
        
        
    }

}

