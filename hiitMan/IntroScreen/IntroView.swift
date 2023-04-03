//
//  IntroView.swift
//  hiitMan
//
//  Created by matt nafarrete on 1/24/23.
//

import Foundation
import UIKit


let mainLogoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "mainLogo")
    imageView.contentMode = .scaleAspectFit
    return imageView
}()

