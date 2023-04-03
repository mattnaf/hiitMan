//
//  InstructionView.swift
//  hiitMan
//
//  Created by matt nafarrete on 1/24/23.
//

import Foundation
import UIKit

let mainScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .white
    return scrollView
}()

let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.distribution = UIStackView.Distribution.equalSpacing
    stackView.alignment = .center
    return stackView
}()

let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "logo")
    imageView.contentMode = .scaleAspectFit
    return imageView
}()

let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Hiitman is an exercise tool to help users monitor their high intensity interval training utilizing the heartbeat sensor on the apple watch."
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .black
    return label
}()

let screenShot1: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "screenshot1")
    imageView.contentMode = .scaleAspectFit
    return imageView
}()

let settingsInstructionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "1)  HI HR (High Intensity Heart Rate) - This picker is used to select your desired high intensity heart rate.\n\n2) HI WIN (High Intensity Window) - This picker is used to select how many seconds you want your high intensity window to last.\n\n3)  CURRENT BPM - This component shows the heart rate that your apple watch is detecting from its sensors.\n\n4) INTS (Intervals) - This picker is used to select how many intervals you would like your work out to last. An interval is one complete cycle of High Intensity and Low Intensity.\n\n5) LI WIN (Low Intensity Window) - This picker is used to select how many seconds you want your low intensity window to last.\n\n6) Start - This button is used to start your work out session after your desired settings have been selected."
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .black
    return label
}()

let screenShot2: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "screenshot2")
    imageView.contentMode = .scaleAspectFit
    return imageView
}()

let sessionInstructionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "1)  This component displays the heart rate that the apple watch is detecting from it’s sensors.\n\n2) Activity Indicator - This box will display the HI HR you selected in the settings screen. When it is Red with arrows pointing up, it means work harder to bring your heart rate to the HI HR. When it is Blue with arrows pointing down, it means to bring your activity intensity down to lower your heart rate below your HI HR. When it is Green with check marks. It means keep doing what you are doing you are in the appropriate level of intensity.\n\n3)  TIME - This displays the elapsed time since you started your workout session.\n\n4) Progress Bar - This bar will fill up when your Activity Indicator is green. When it fills up your intensity level should flip. If your sound is on there are also audio ques associated.\n\n5) INT - This displays how many intervals you have completed vs how many you have left.\n\n6) Pause - This button is used to Pause your work out session once pressed your session will pause and give you the option to resume when you are ready or exit the session early."
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .black
    return label
}()




let instructionsLabel = UILabel()

