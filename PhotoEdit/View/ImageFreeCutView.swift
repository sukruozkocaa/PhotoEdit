//
//  ImageFreeCutView.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 7.12.2022.
//

import Foundation
import QuartzCore
import UIKit

protocol ImageFreeCutViewDelegate: AnyObject {
    func imageFreeCutView(_ imageFreeCutView: ImageFreeCutView, didCut image: UIImage? )
}

class ImageFreeCutView: UIView {
    var imageView: UIImageView!
    var imageCutShapeLayer: CAShapeLayer!
    
    weak var delegate: ImageFreeCutViewDelegate?
    
    var imageToCut: UIImage? {
        didSet {
            imageView.image = imageToCut
        }
    }
    
    private var drawPoints: [CGPoint] = [] {
        didSet {
            drawShape()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        imageView = UIImageView(frame: frame)
        addSubview(imageView)
        imageView.image = imageToCut
        imageView.isUserInteractionEnabled = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageCutShapeLayer = CAShapeLayer()
        imageCutShapeLayer.frame = imageView.bounds
        imageCutShapeLayer.fillColor = UIColor.clear.cgColor
        imageCutShapeLayer.lineWidth = 1
        imageCutShapeLayer.strokeColor = UIColor.black.cgColor
        imageCutShapeLayer.lineJoin = CAShapeLayerLineJoin.round //????
        imageCutShapeLayer.lineDashPattern = [4,4]
        imageView.layer.addSublayer(imageCutShapeLayer)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        imageCutShapeLayer.frame = imageView.bounds
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchPosition = touches.first?.location(in: imageView) else { return }
        drawPoints.append(touchPosition)
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touchPosition = touches.first?.location(in: imageView) else { return }
        drawPoints.append(touchPosition)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchPosition = touches.first?.location(in: imageView) else { return }
        drawPoints.append(touchPosition)
        guard let cgPath = imageCutShapeLayer.path else { return }
        let path = UIBezierPath(cgPath: cgPath)
        path.close()
        imageCutShapeLayer.path = path.cgPath
        delegate?.imageFreeCutView(self, didCut: cropImage())
        resetShape()
    }

    private func resetShape() {
        drawPoints = []
        imageView.layer.mask = nil
    }

    private func drawShape() {
        if drawPoints.isEmpty {
            imageCutShapeLayer.path = nil
            return
        }

        let path = UIBezierPath()
        for (index, point) in drawPoints.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        imageCutShapeLayer.path = path.cgPath
    }
    
    private func cropImage() -> UIImage? {
        guard let originalImage = imageToCut, let cgPath = imageCutShapeLayer.path else { return nil }
        let path = UIBezierPath(cgPath: cgPath)
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0)
        path.addClip()
        originalImage.draw(in: imageView.bounds)

        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}
