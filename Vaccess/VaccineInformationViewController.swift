//"
//  VaccineInformationViewController.swift
//  Vaccess
//
//  Created by emil on 2020-06-17.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import WebKit

class VaccineInformationViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.folkhalsomyndigheten.se/smittskydd-beredskap/vaccinationer/vacciner-a-o/baltros/")!
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
