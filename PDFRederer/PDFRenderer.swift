//
//  PDFRenderer.swift
//  PDFRederer
//
//  Created by Fred Faust on 2/12/15.
//  Copyright (c) 2015 Fred Faust. All rights reserved.
//

import UIKit
import CoreText

class PDFRenderer: NSObject {
    
    func drawTableAt(origin: CGPoint, withRowHeight rowHeight: Int, andColumnWidth columnWidth: Int, andRowcount numberOfRows: Int, andColumnCount numberOfColumns: Int) {
        
        for var i = 0; i <= numberOfRows; i++ {
            
            let newOrigin : CGFloat = origin.y + CGFloat(rowHeight * i)
            let from : CGPoint      = CGPointMake(origin.x, newOrigin)
            let to : CGPoint        = CGPointMake(origin.x + CGFloat(numberOfColumns * columnWidth), newOrigin)
            
            self.drawLineFromPoint(fromPoint: from, toPoint: to)
            
        }
        
        for var i = 0; i <= numberOfColumns; i++ {
            
            let newOrigin : CGFloat = origin.x + CGFloat(columnWidth * i)
            let from : CGPoint      = CGPointMake(newOrigin, origin.y)
            let to : CGPoint        = CGPointMake(newOrigin, CGFloat(origin.y + CGFloat(numberOfRows * rowHeight)))
            
            self.drawLineFromPoint(fromPoint: from, toPoint: to)
            
        }
        
    }
    
    func drawTableDataAt(origin: CGPoint, withRowHeight rowHeight: Int, andColumnWidth columnWidth: Int, andRowCount numberOfRows: Int, andColumnCount numberOfColumns: Int) {
        
        let padding : CGFloat = 10
        
        let headers = ["Quantity","Description","Unit Price", "Total", ""]
        
        let invoiceInfo1  = ["1","Development","$1000","$1000",""]
        let invoiceInfo2  = ["1","Development","$1000","$1000",""]
        let invoiceInfo3  = ["1","Development","$1000","$1000",""]
        let invoiceInfo4  = ["1","Development","$1000","$1000",""]
        
        let allInfo = [headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4,]
        
        for var i = 0; i < allInfo.count; i++ {
            
            let infoToDraw = allInfo[0]
            
            for var j = 0; j < numberOfColumns; j++ {
                
                let newOriginX      = origin.x + CGFloat(j * columnWidth)
                let newOriginY      = origin.y + (CGFloat(i + 1) * CGFloat(rowHeight))
                let frame : CGRect  = CGRectMake(newOriginX + padding, newOriginY + padding, CGFloat(columnWidth), CGFloat(rowHeight))
                
                self.drawText(infoToDraw[j], inFrame: frame)
                
            }
            
        }
        
    }
    
    func drawPDF(filename: String) {
        
        // Create the PDF context using the default page size of 612 x 792
        UIGraphicsBeginPDFContextToFile(filename, CGRectZero, nil)
        
        // start a new page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil)
        
        self.drawLabels()
        self.drawLogo()
        
        let xOrigin = 50
        let yOrigin = 300
        
        let rowHeight   = 50
        let columnWidth = 120
        
        let numberOfRows    = 7
        let numberOfColumns = 4
        
        self.drawTableAt(CGPointMake(CGFloat(xOrigin), CGFloat(yOrigin)), withRowHeight: rowHeight, andColumnWidth: columnWidth, andRowcount: numberOfRows, andColumnCount: numberOfColumns)
        
        self.drawTableDataAt(CGPointMake(CGFloat(xOrigin), CGFloat(yOrigin)), withRowHeight: rowHeight, andColumnWidth: columnWidth, andRowCount: numberOfRows, andColumnCount: numberOfColumns)
        
        UIGraphicsEndPDFContext()
        
    }
    
    func drawLogo() {
        
        let objects  = NSBundle.mainBundle().loadNibNamed("InvoiceView", owner: nil, options: nil)
        let mainView = objects[0] as! UIView
        
        for view in mainView.subviews {
            
            if view.isKindOfClass(UIImageView) {
                
                let logo : UIImage = UIImage(named: "ray-logo.png")!
                self.drawImage(image: logo, inRect: view.frame)
            }
            
        }
        
    }
    
    func drawText(textToDraw: String, inFrame frameRect: CGRect) {
        
        let stringRef : CFStringRef = textToDraw
        
        // prepare the text using a core text framesetter
        let currentText : CFAttributedStringRef = CFAttributedStringCreate(nil, stringRef, nil)
        let framesetter : CTFramesetterRef      = CTFramesetterCreateWithAttributedString(currentText)
        
        let framePath : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddRect(framePath, nil, frameRect)
        
        // get the frame that will do the rendering
        let currentRange : CFRange  = CFRangeMake(0, 0)
        let frameRef : CTFrameRef   = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity)
        
        // core text draws from the bottom left corner up so flip the current transform prior to drawing
        CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2)
        CGContextScaleCTM(currentContext, 1.0, -1.0)

        CTFrameDraw(frameRef, currentContext)

        CGContextScaleCTM(currentContext, 1.0, -1.0)
        CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2)
        
    }
    
    func drawImage(image imageToDraw: UIImage, inRect rect: CGRect) {
        
        imageToDraw.drawInRect(rect)
        
    }
    
    func drawLabels() {
        
        let objects  = NSBundle.mainBundle().loadNibNamed("InvoiceView", owner: nil, options: nil)
        let mainView = objects[0] as! UIView
        
        for view in mainView.subviews {
            
            if view.isKindOfClass(UILabel) {
                
                let label : UILabel = view as! UILabel
                
                self.drawText(label.text!, inFrame: label.frame)
                
            }
            
        }
        
    }
    
    func drawLineFromPoint(fromPoint from: CGPoint, toPoint to: CGPoint) {
        
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetLineWidth(context, 2.0)
        
        let colorSpace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let components = [0.2, 0.2, 0.2, 0.3] as [CGFloat]
        
        let color : CGColorRef = CGColorCreate(colorSpace, components)!
        
        CGContextSetStrokeColorWithColor(context, color)
        
        CGContextMoveToPoint(context, from.x, from.y)
        CGContextAddLineToPoint(context, to.x, to.y)
        
        CGContextStrokePath(context)

    }
   
}
