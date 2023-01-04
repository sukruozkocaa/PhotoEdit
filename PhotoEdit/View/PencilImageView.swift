//
//  PencilImageView.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 9.12.2022.
//

import Foundation
import UIKit

class PencilImageView: UIImageView {
    private lazy var path = UIBezierPath()
    private lazy var previousTouchPoint = CGPoint.zero
    private lazy var shapeLayer = CAShapeLayer()
    private lazy var color = UIColor()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView(){
        layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = 5
        shapeLayer.strokeColor = UIColor.red.cgColor
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let location = touches.first?.location(in: self) { previousTouchPoint = location }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let location = touches.first?.location(in: self) {
            path.move(to: location)
            path.addLine(to: previousTouchPoint)
            previousTouchPoint = location
            shapeLayer.path = path.cgPath
        }
    }
}
