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

    // 1st View
    let redView = UIView()
    redView.backgroundColor = .red
    let redViewLabel = UILabel()
    redViewLabel.text = "Hi, swipe me!"
    redViewLabel.textColor = .white
    redViewLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
    redView.addSubview(redViewLabel)
    redViewLabel.sizeToFit()
    redViewLabel.center = CGPoint(x: slider.bounds.width / 2.0, y: slider.bounds.height / 2.0)

    // 2nd View
    let blueView = UIView()
    blueView.backgroundColor = .blue
    let blueViewLabel = UILabel()
    blueViewLabel.text = "You can also enable \nauto slide!"
    blueViewLabel.numberOfLines = 0
    blueViewLabel.textColor = .white
    blueViewLabel.textAlignment = .center
    blueViewLabel.font = UIFont.boldSystemFont(ofSize: 36.0)
    blueView.addSubview(blueViewLabel)
    blueViewLabel.sizeToFit()
    blueViewLabel.center = CGPoint(x: slider.bounds.width / 2.0, y: slider.bounds.height / 2.0)

    // 3rd View
    let dogsImageView = UIImageView(image: #imageLiteral(resourceName: "dogs.jpg"))
    dogsImageView.contentMode = .scaleAspectFill

    // Setting slider
    slider.viewArray = [redView, blueView] // Set UIView Array to `viewArray`
    slider.slideTimeInterval = 1.0 // default is 3.0.
    slider.viewArray.append(dogsImageView) // You can add views later
    slider.delegate = self

  }

  @IBAction func toggleAutoSlide(_ sender: UISwitch) {
    slider.isAutoSlideEnabled = sender.isOn
  }

}

extension ViewController: InfiniteViewSliderDelegate {
  func sliderDidSlide(_ slider: InfiniteViewSlider, contentOffset: Double, numberOfViews: Int, currentViewIndex: Int) {
    print(contentOffset, numberOfViews, currentViewIndex)
  }
}
