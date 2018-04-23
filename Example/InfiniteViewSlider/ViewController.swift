//
//  ViewController.swift
//  InfiniteViewSlider
//
//  Created by draupnir45 on 04/22/2018.
//  Copyright (c) 2018 draupnir45. All rights reserved.
//

import UIKit
import InfiniteViewSlider

class ViewController: UIViewController {

  @IBOutlet var slider: InfiniteViewSlider!

  override func viewDidLoad() {
    super.viewDidLoad()

    // View Items
    let redView = UIView()
    let redViewLabel = UILabel()
    redView.addSubview(redViewLabel)
    let blueView = UIView()
    let blueViewLabel = UILabel()
    blueView.addSubview(blueViewLabel)
    let dogsImageView = UIImageView(image: #imageLiteral(resourceName: "dogs.jpg"))

    // Setting slider
    slider.slidingSubviews = [redView, blueView, dogsImageView] // Set UIView Array to `viewArray`
    slider.autoSlideTimeInterval = 1.0 // default is 3.0.
    slider.delegate = self
    print(redView.frame)

    // 1st View
    redView.backgroundColor = .red
    redViewLabel.text = "Hi, swipe me!"
    redViewLabel.textColor = .white
    redViewLabel.textAlignment = .center
    redViewLabel.font = UIFont.boldSystemFont(ofSize: 36.0)

    // Label AutoLayout
    redViewLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: redViewLabel, attribute: .centerX, relatedBy: .equal, toItem: redView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: redViewLabel, attribute: .centerY, relatedBy: .equal, toItem: redView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                                 ])

    // 2nd View
    blueView.backgroundColor = .blue
    blueViewLabel.text = "You can also\nenable auto slide!"
    blueViewLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
    blueViewLabel.textColor = .white
    blueViewLabel.textAlignment = .center
    blueViewLabel.numberOfLines = 0

    // Label AutoLayout
    blueViewLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: blueViewLabel, attribute: .centerX, relatedBy: .equal, toItem: blueView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: blueViewLabel, attribute: .centerY, relatedBy: .equal, toItem: blueView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
      ])

    // 3rd View
    dogsImageView.contentMode = .scaleAspectFill
  }

  @IBAction func toggleAutoSlide(_ sender: UISwitch) {
    slider.isAutoSlideEnabled = sender.isOn
  }
}

extension ViewController: InfiniteViewSliderDelegate {
  func sliderDidSlide(_ slider: InfiniteViewSlider, progress: Double, numberOfViews: Int, currentViewIndex: Int) {
    print(progress, numberOfViews, currentViewIndex)
  }
}
