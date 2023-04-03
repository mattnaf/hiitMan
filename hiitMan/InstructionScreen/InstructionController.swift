//
//  InstructionController.swift
//  hiitMan
//
//  Created by matt nafarrete on 1/24/23.
//

import UIKit

import UIKit

class InstructionViewController: UIViewController {

    var height: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
      for subview in mainScrollView.subviews {
          height = height + subview.frame.size.height
          print(subview.frame)
      }
  }

    func setupUI() {
        
        let spacingUnit = view.bounds.height/100
        
        
        view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        mainScrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor)
            
        ])
        
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(screenShot1)
        stackView.addArrangedSubview(settingsInstructionLabel)
        stackView.addArrangedSubview(screenShot2)
        stackView.addArrangedSubview(sessionInstructionLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,constant: spacingUnit * 4),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            screenShot1.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: spacingUnit * 4),
            screenShot1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            screenShot1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            settingsInstructionLabel.topAnchor.constraint(equalTo: screenShot1.bottomAnchor,constant: spacingUnit * 4),
            settingsInstructionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            settingsInstructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            screenShot2.topAnchor.constraint(equalTo: settingsInstructionLabel.bottomAnchor,constant: spacingUnit * 4),
            screenShot2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            screenShot2.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sessionInstructionLabel.topAnchor.constraint(equalTo: screenShot2.bottomAnchor,constant: spacingUnit * 4),
            sessionInstructionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            sessionInstructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
