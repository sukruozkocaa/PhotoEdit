//
//  HeaderCell.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 1.12.2022.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            headerLabel.textColor = isSelected ? .white : .systemGray
            headerLabel.font = isSelected ? UIFont(name: "Copperplate", size: 16) : UIFont(name: "Copperplate", size: 15)
            headerLabel.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
            headerLabel.layer.borderWidth = isSelected ? 1 : 0
            headerLabel.layer.cornerRadius = isSelected ? 5 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with header: String) {
        headerLabel.text = header
    }
}
