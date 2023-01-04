//
//  LineThicknessCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 9.12.2022.
//

import UIKit

protocol selectedLineThicknessProtocol {
    func sendThickness(thickness: Double)
}

class LineThicknessCell: UICollectionViewCell {

    @IBOutlet weak var slider: UISlider!
    var delegate: selectedLineThicknessProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func sliderValue(_ sender: UISlider) {
        delegate?.sendThickness(thickness: Double(slider.value))
    }
}
