//
//  Utilities.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/6/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import Foundation
import AsyncDisplayKit

extension UIColor {
    
    static func darkBlueColor() -> UIColor {
        return UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1.0)
    }
    
    static func lightBlueColor() -> UIColor {
        return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    static func duskColor() -> UIColor {
        return UIColor(red: 255/255.0, green: 181/255.0, blue: 68/255.0, alpha: 1.0)
    }
    
    static func customOrangeColor() -> UIColor {
        return UIColor(red: 40/255.0, green: 43/255.0, blue: 53/255.0, alpha: 1.0)
    }
    
}

extension Int {
    func getFancyNumber() -> String? {
        let number: Double = (Double(self) / 1000.0)
        
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = 1
        numberFormater.minimumFractionDigits = 1
        let numberString = numberFormater.string(from: NSNumber(value: number))
        return "\(numberString!)k"
    }
}

extension UIView {
    func makeRoundedView(size: CGSize?, borderWidth width: CGFloat, color: UIColor? = .white) -> UIView {
        let rect = CGRect(origin: .zero, size: bounds.size)
        
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        maskPath.addClip()
        UIColor.flatWhite.set()
        maskPath.fill()
        self.draw(rect)
        UIColor.flatWhite.set()
        maskPath.stroke()
        
        return self
    }
}

extension UIImage {
    
    func makeRoundedImage(size: CGSize, borderWidth width: CGFloat, color: UIColor? = .white) -> UIImage {

        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
        
        maskPath.addClip()
        UIColor.white.set()
        maskPath.fill()
        self.draw(in: rect)
        if(width > 0) {
            maskPath.lineWidth = width
            color?.set()
            maskPath.stroke()
        }
        let modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return modifiedImage ?? self
    }
    func makeCircularImage(size: CGSize, borderWidth width: CGFloat, color: UIColor? = .white) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)
        
        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
        
        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)
        
        // clip to the circle
        circle.addClip()
        
        UIColor.white.set()
        circle.fill()
        
        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)
        
        // create a border (for white background pictures)
        if width > 0 {
            circle.lineWidth = width;
            color?.set()
            circle.stroke()
        }
        
        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext();
        
        return roundedImage ?? self
    }
    
}

extension String {
    func checkForBrackets() -> String {
        var mystring = String(self)!
        let prefix = mystring.hasPrefix("[")
        let suffix = mystring.hasSuffix("]")
        
        if(prefix && suffix) {
            mystring.remove(at: mystring.startIndex)
            mystring.remove(at: mystring.index(before: mystring.endIndex))
            return mystring
        } else { return self }
    }
}

extension NSAttributedString {
    
    static func attributedString(string: String?, fontSize size: CGFloat, color: UIColor?) -> NSAttributedString? {
        guard let string = string else { return nil }
        
        let attributes = [NSForegroundColorAttributeName: color ?? UIColor.black,
                          NSFontAttributeName: AppFont(size: size, bold: true)]
        
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        
        return attributedString
    }
    
}
