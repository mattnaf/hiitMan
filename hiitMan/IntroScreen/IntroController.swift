//
//  IntroController.swift
//  hiitMan
//
//  Created by matt nafarrete on 1/24/23.
//

import UIKit

class IntroController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainLogoImageView.center = view.center
    }
    

    private func setup() {
        view.backgroundColor = .white
        
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.animate()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
            self.fadeOut()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            let newVC = InstructionViewController()
            newVC.modalPresentationStyle = .fullScreen
            newVC.modalTransitionStyle = .crossDissolve
            self.present(newVC, animated: true)
        })
    }
    
    private func animate() {
        
        view.addSubview(mainLogoImageView)
        NSLayoutConstraint.activate([
            mainLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            mainLogoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4)
        ])
        
        UIView.animate(withDuration: 3, animations: {
            print("animating")
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            mainLogoImageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        })
        
        
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 1, animations: {
            mainLogoImageView.alpha = 0
        })
    }

}
