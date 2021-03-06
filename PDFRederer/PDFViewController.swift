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
    
    // MARK: - Outlets & Properties
    @IBOutlet weak var webView: UIWebView!

    // MARK: - Actions
    func getPDFFileName () -> String {
        
        let fileName = "/invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        
        return documentsPath + fileName
    }
    
    func showPDFFile() {
        
        let fileName = "/invoice.pdf"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true)[0] as String
        
        let pdfFileUrl = URL(string: documentsPath + fileName)
        let request = URLRequest(url: pdfFileUrl!)
        
        webView.scalesPageToFit = true
        webView.loadRequest(request)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let fileName = getPDFFileName()
        PDFRenderer().drawPDF(fileName)
        showPDFFile()
    }

}
