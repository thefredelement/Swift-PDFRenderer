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
    
    func getPDFFileName () -> String {
        
        let fileName = "invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        let pdfFileName = documentsPath.stringByAppendingPathComponent(fileName)
        
        return pdfFileName
        
    }
    
    func showPDFFile() {
        
        let fileName = "invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        let pdfFileName = documentsPath.stringByAppendingPathComponent(fileName)
        
        let webView : UIWebView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        let url : NSURL = NSURL(fileURLWithPath: pdfFileName)
        let request : NSURLRequest = NSURLRequest(URL: url)
        
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        
        self.view.addSubview(webView)
    
    
    }

}
