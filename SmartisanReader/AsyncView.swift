//
//  AsyncView.swift
//  SmartisanReader
//
//  Created by lixun on 2017/1/12.
//  Copyright © 2017年 sunshine. All rights reserved.
//

import UIKit

class AsyncView: UIView {

    override  init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.layer.contentsScale = UIScreen.main.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if !(self.window != nil) {
            
        }else if !(self.layer.contents != nil) {
            self.layer.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ layer: CALayer, in ctx: CGContext) {
        super.draw(layer, in: ctx)
        DispatchQueue.global().async {
            self.displayLayer(layer, rect: layer.frame)
        }
    }
    
    
    func displayLayer(_ layer: CALayer, rect: CGRect)  {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, layer.contentsScale)
        
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            context.saveGState()
        
            if self.backgroundColor != UIColor.clear, let backgroundColor = self.backgroundColor {
                context.setFillColor(backgroundColor.cgColor)
                context.fill(rect)
            }
            
            let isTrue =  drawInRect(rect, context: context)
            context.restoreGState()
            
            
            if isTrue {
                let CGImage: CGImage = context.makeImage()!
                let image = UIImage.init(cgImage: CGImage)
                DispatchQueue.main.async {
                    self.layer.contents = image.cgImage
                }
                
            }
            UIGraphicsEndImageContext()
        }
    }
    
    
   open func drawInRect(_ rect: CGRect, context: CGContext) -> Bool{
        return true
    }

}





class AsyncRichTextView: AsyncView {
    
    lazy var showImageView1: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var showImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var showImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    lazy var souecrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    
    public var layout: CellLayout!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ frame: CGRect,  layout: CellLayout) {
        self.init(frame: frame)
        self.layout = layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawInRect(_ rect: CGRect, context: CGContext) -> Bool {
        
        if self.layout == nil {
            return true
        }
        
        let nameAttStr = NSMutableAttributedString.init(string: layout.cellModel.title)
        nameAttStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 17.0), NSForegroundColorAttributeName : UIColor.black], range: NSRange.init(location: 0, length: nameAttStr.length))
        
        nameAttStr.draw(in: CGRect.init(x: CellLayout.nameLeftPadding, y: CellLayout.nameTopPadding, width: CellLayout.screenWidth - 20.0, height: layout.titleHeight))
        
        if layout.cellModel.content != "" {
            let contentAttStr = NSMutableAttributedString.init(string: layout.cellModel.content)
            contentAttStr.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 13.0), NSForegroundColorAttributeName : UIColor.lightGray], range: NSRange.init(location: 0, length: contentAttStr.length))
            
            contentAttStr.draw(in: CGRect.init(x: CellLayout.nameLeftPadding, y: CellLayout.nameTopPadding + layout.titleHeight + CellLayout.contentLabelTopPadding, width: CellLayout.screenWidth - 20.0, height: layout.contentHeight))
            
        }else{
            
        }
        return true
    }
}


