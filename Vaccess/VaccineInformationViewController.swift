//"
//  VaccineInformationViewController.swift
//  Vaccess
//
//  Created by emil on 2020-06-17.
//  Copyright © 2020 Ryd Corporation. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
class VaccineInformationViewController: UIViewController {

    
    var currentVaccine: String?
    
    @IBOutlet weak var vaccineNameLabel: UILabel!
    
    @IBOutlet weak var ingressLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "https://www.folkhalsomyndigheten.se/smittskydd-beredskap/vaccinationer/vacciner-a-o/\(currentVaccine!)/"
        let url = URL(string: string)!
        //https://www.folkhalsomyndigheten.se/smittskydd-beredskap/vaccinationer/vacciner-a-o/baltros/
        
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.load(request)
        updateTextView()
        
        
        
        
     /*   webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
            do {
                print("innerHTML \(innerHTML)")

                let webSiteResponse = try WebSiteResponse(innerHTML: innerHTML)
            } catch {}
        }
        )*/
        
       
            do {
                let contents = try String(contentsOf: url)
                let doc = try SwiftSoup.parse(contents)
                //let mainText = try doc.getElementsByClass("content-3-1 rs-listen").text()
                let mainText = try doc.getElementsByTag("p").text()

                let ingress = try doc.getElementsByClass("intro").text()
                //let title = try doc.getElementsByClass("content-2 rs-listen ").text()
                let title = try doc.getElementsByTag("h1").text()
                
                let string = "Sjukdomen covid-19 orsakas av ett annat virus än influensa. Läs mer om covid-19"
                
                
                if mainText.localizedStandardContains(string) {
                    let parsed = mainText.replacingOccurrences(of: string, with: "")
                    bodyLabel.text = parsed                //let webSiteResponse = try WebSiteResponse(innerHTML: contents)

                }
                else {
                    bodyLabel.text = mainText
                }
                vaccineNameLabel.text = title
                ingressLabel.text = ingress
            } catch {
                // contents could not be loaded
            }
    }
    
    func updateTextView() {
        let path = "https://www.folkhalsomyndigheten.se/smittskydd-beredskap/vaccinationer/vacciner-a-o/"
        let text = textView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "Folkhälsomyndighetens hemsida")
        
        let font = textView.font
        let color = textView.textColor
        textView.attributedText = attributedString
        textView.font = font
        textView.textColor = color
        textView.textAlignment = .left
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        /*if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }*/
        dismiss(animated: true, completion: nil)

    }
}
