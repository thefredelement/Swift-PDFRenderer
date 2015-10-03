//
//  PDFViewController.swift
//  PDFRederer
//
//  Created by Fred Faust on 2/12/15.
//  Copyright (c) 2015 Fred Faust. All rights reserved.
//

import UIKit
import CoreText

class PDFViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var webView: UIWebView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        
        let fileName = getPDFFileName()

        PDFRenderer().drawPDF(fileName)
        
        showPDFFile()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    func getPDFFileName () -> String {
        
        let fileName = "/invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        return documentsPath + fileName
        
    }
    
    func showPDFFile() {
        
        let fileName = "/invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        let pdfFileUrl = NSURL(string: documentsPath + fileName)
        
        let request : NSURLRequest = NSURLRequest(URL: pdfFileUrl!)
        
        self.webView.scalesPageToFit = true
        self.webView.loadRequest(request)
    
    }

}
