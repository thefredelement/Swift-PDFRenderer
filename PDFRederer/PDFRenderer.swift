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
    
    func drawTableAt(_ origin: CGPoint, withRowHeight rowHeight: Int, andColumnWidth columnWidth: Int, andRowcount numberOfRows: Int, andColumnCount numberOfColumns: Int) {

        for i in 0..<numberOfRows {
            
            let newOrigin = origin.y+CGFloat(rowHeight * i)
            let from = CGPoint(
                x: origin.x,
                y: newOrigin)
            let to = CGPoint(
                x: origin.x + CGFloat(numberOfColumns * columnWidth),
                y: newOrigin)
            
            drawLineFromPoint(
                fromPoint: from,
                toPoint: to)
            
        }

        for i in 0..<numberOfColumns {

            let newOrigin = origin.x + CGFloat(columnWidth * i)
            let from = CGPoint(
                x: newOrigin,
                y: origin.y)
            let to = CGPoint(
                x: newOrigin,
                y: CGFloat(origin.y + CGFloat(numberOfRows * rowHeight)))
            
            drawLineFromPoint(
                fromPoint: from,
                toPoint: to)
            
        }
    }
    
    func drawTableDataAt(_ origin: CGPoint, withRowHeight rowHeight: Int, andColumnWidth columnWidth: Int, andRowCount numberOfRows: Int, andColumnCount numberOfColumns: Int) {
        
        let padding : CGFloat = 10
        let headers = ["Quantity","Description","Unit Price", "Total", ""]
        
        let invoiceInfo1  = ["1","Development","$1000","$1000",""]
        let invoiceInfo2  = ["1","Development","$1000","$1000",""]
        let invoiceInfo3  = ["1","Development","$1000","$1000",""]
        let invoiceInfo4  = ["1","Development","$1000","$1000",""]
        
        let allInfo = [headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4,]
        
        for i in 0 ..< allInfo.count {
            
            let infoToDraw = allInfo[0]
            
            for j in 0 ..< numberOfColumns {
                
                let newOriginX      = origin.x + CGFloat(j * columnWidth)
                let newOriginY      = origin.y + (CGFloat(i + 1) * CGFloat(rowHeight))
                let frame : CGRect  = CGRect(x: newOriginX + padding, y: newOriginY + padding, width: CGFloat(columnWidth), height: CGFloat(rowHeight))
                
                self.drawText(infoToDraw[j], inFrame: frame)
                
            }
        }
    }
    
    func drawPDF(_ filename: String) {
        
        // Create the PDF context using the default page size of 612 x 792
        UIGraphicsBeginPDFContextToFile(filename, CGRect.zero, nil)
        
        // start a new page
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 612, height: 792), nil)
        
        drawLabels()
        drawLogo()
        
        let xOrigin = 50
        let yOrigin = 300
        
        let rowHeight   = 50
        let columnWidth = 120
        
        let numberOfRows    = 7
        let numberOfColumns = 4
        
        drawTableAt(
            CGPoint(x: CGFloat(xOrigin), y: CGFloat(yOrigin)),
            withRowHeight: rowHeight,
            andColumnWidth: columnWidth,
            andRowcount: numberOfRows,
            andColumnCount: numberOfColumns)
        
        drawTableDataAt(
            CGPoint(x: CGFloat(xOrigin), y: CGFloat(yOrigin)),
            withRowHeight: rowHeight,
            andColumnWidth: columnWidth,
            andRowCount: numberOfRows,
            andColumnCount: numberOfColumns)
        
        UIGraphicsEndPDFContext()
    }
    
    func drawLogo() {
        
        let objects  = Bundle.main.loadNibNamed(
            "InvoiceView",
            owner: nil,
            options: nil)

        guard let mainView = objects?[0] as? UIView else {
            print("Could not get main view")
            return
        }

        mainView.subviews.forEach {
            if $0.isKind(of: UIImageView.self) {

                let logo : UIImage = UIImage(named: "ray-logo.png")!
                drawImage(image: logo, inRect: $0.frame)
            }
        }
    }
    
    func drawText(_ textToDraw: String, inFrame frameRect: CGRect) {
        
        let stringRef = textToDraw as CFString
        
        // prepare the text using a core text framesetter
        guard let currentText = CFAttributedStringCreate(nil, stringRef, nil) else {
            print("Could not get current text!")
            return
        }
        let framesetter : CTFramesetter      = CTFramesetterCreateWithAttributedString(currentText)
        
        let framePath = CGMutablePath()
        framePath.addRect(frameRect)
        
        // get the frame that will do the rendering
        let currentRange : CFRange  = CFRangeMake(0, 0)
        let frameRef : CTFrame   = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
        
        let currentContext = UIGraphicsGetCurrentContext()!
        
        currentContext.textMatrix = CGAffineTransform.identity
        
        // core text draws from the bottom left corner up 
        // so flip the current transform prior to drawing
        currentContext.translateBy(x: 0, y: frameRect.origin.y*2)
        currentContext.scaleBy(x: 1.0, y: -1.0)

        CTFrameDraw(frameRef, currentContext)

        currentContext.scaleBy(x: 1.0, y: -1.0)
        currentContext.translateBy(x: 0, y: (-1)*frameRect.origin.y*2)
        
    }
    
    func drawImage(image imageToDraw: UIImage, inRect rect: CGRect) {
        
        imageToDraw.draw(in: rect)
    }
    
    func drawLabels() {
        
        guard
            let objects  = Bundle.main.loadNibNamed("InvoiceView", owner: nil, options: nil),
            let mainView = objects[0] as? UIView else {
                print("Could not get objects/mainView")
                return
        }
        
        mainView.subviews.forEach {
            
            if $0.isKind(of: UILabel.self) {
                guard let label = $0 as? UILabel else {
                    return // loop control
                }
                drawText(label.text!, inFrame: label.frame)
            }
        }
    }
    
    func drawLineFromPoint(fromPoint from: CGPoint, toPoint to: CGPoint) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Could not get current grpahics context")
            return
        }

        context.setLineWidth(2.0)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components = [0.2, 0.2, 0.2, 0.3] as [CGFloat]
        
        let color = CGColor(
            colorSpace: colorSpace,
            components: components)!
        
        context.setStrokeColor(color)
        context.move(to: CGPoint(x: from.x, y: from.y))
        context.addLine(to: CGPoint(x: to.x, y: to.y))
        context.strokePath()
    }
   
}
