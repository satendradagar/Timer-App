//
//  SSButton.swift
//  ThinPrint
//
//  Created by Satendra Dagar on 12/01/18.
//  Copyright © 2018 TP. All rights reserved.
//

import Foundation
import Cocoa

@IBDesignable
class SSButton: NSButton
{
    @IBInspectable var bgColor: NSColor?
    @IBInspectable var textColor: NSColor?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.updateTheme()
    }
    
    func updateTheme()  {
        if let textColor = textColor, let font = font
        {
            let style = NSMutableParagraphStyle()
            style.alignment = self.alignment
            
            let attributes =
                [
                    NSAttributedStringKey.foregroundColor: textColor,
                    NSAttributedStringKey.font: font,
                    
                    NSAttributedStringKey.paragraphStyle: style
                    ] as [NSAttributedStringKey : Any]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            self.attributedTitle = attributedTitle
        }
        self.setNeedsDisplay()
        
    }
    override func draw(_ dirtyRect: NSRect)
    {
        if let bgColor = bgColor
        {
            bgColor.setFill()
            __NSRectFill(dirtyRect)
        }
        
        super.draw(dirtyRect)
    }
}
