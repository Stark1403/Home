//
//  UIImage+Extension.swift
//  ZeusAppExternos
//
//  Created by DSI Soporte Tecnico on 29/08/23.
//

import Foundation
import UIKit

extension UIImage {
    
    func createSelectionIndicatorTabBarItem(color: UIColor, size: CGSize, lineHeight: CGFloat, cornerRadius: CGFloat = 32.0) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let rect = CGRect(x: 0, y: 0, width: size.width, height: lineHeight * 2)
            
            // Fill background color
            UIColor.clear.setFill()
            ctx.fill(rect)
            
            // Draw indicator line with corner radius
            let indicatorRect = CGRect(x: 0, y: 0, width: size.width, height: lineHeight)
            let indicatorPath = UIBezierPath(roundedRect: indicatorRect, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            color.setFill()
            indicatorPath.fill()
        }
        
        return image
    }
    
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression, isOpaque: false) else { break }
            holderImage = newImage
        }
        return Data()
    }
  
  func maskWithGradientColor(colors: [CGColor]) -> UIImage? {
    
    let maskImage = self.cgImage
    let width = self.size.width
    let height = self.size.height
    let bounds = CGRect(x: 0, y: 0, width: width, height: height)
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bitmapContext = CGContext(data: nil,
                                  width: Int(width),
                                  height: Int(height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: bitmapInfo.rawValue)
    
    let locations:[CGFloat] = [0.0, 1.0]
    let cfcolors = colors as CFArray
    let gradient = CGGradient(colorsSpace: colorSpace, colors: cfcolors, locations: locations)
    let startPoint = CGPoint(x: width/2, y: 0)
    let endPoint = CGPoint(x: width/2, y: height)
    
    bitmapContext!.clip(to: bounds, mask: maskImage!)
    bitmapContext!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
    
    if let cImage = bitmapContext!.makeImage() {
      let coloredImage = UIImage(cgImage: cImage)
      return coloredImage
    }
    else  {
      return nil
    }
  }
}

