//
//  PhotoModel.swift
//  PhotoEdit
//
//  Created by Şükrü Özkoca on 23.12.2022.
//

import Foundation
import Photos
import UIKit


struct Photo: Identifiable {
    var id = UUID()
    var photo: UIImage
}

