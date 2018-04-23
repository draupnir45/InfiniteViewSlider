
//
//  InfiniteViewSlider.swift
//  FlameKit
//
//  Created by 박종찬 on 2018. 1. 15..
//

import UIKit

public protocol InfiniteViewSliderDelegate: class {
  /// Tells delegate that slider is sliding, status.
  ///
  /// - Parameters:
  ///   - slider: slider itself
  ///   - contentOffset: progress of sliding. As an example, returns 2.5 if sliding half way from view 2 to view 3...
  ///   - numberOfViews: number of views in `slidingSubviews`.
  ///   - currentViewIndex: index of current view in `slidingSubviews`.
  func sliderDidSlide(_ slider: InfiniteViewSlider, progress: Double, numberOfViews: Int, currentViewIndex: Int)
}

@objcMembers open class InfiniteViewSlider: UIView, UIScrollViewDelegate {

  // MARK: - Open Properties

  open weak var delegate: InfiniteViewSliderDelegate?

  open var autoSlideTimeInterval: TimeInterval = 3.0

  open var slidingSubviews: [UIView] = [] {
    didSet {
      layoutSubviews()
      guard slidingSubviews.count > 0 else { return }
      _ = self.slidingSubviews.map { subview in
        subview.frame = CGRect.init(origin: CGPoint.init(x: scrollView.frame.width, y: 0.0), size: scrollView.frame.size)
        subview.clipsToBounds = true
        self.scrollView.addSubview(subview)
        subview.isHidden = true
      }

      if slidingSubviews.indices.contains(currentViewIndex) {
        slidingSubviews[currentViewIndex].isHidden = false
      }

      self.scrollView.isScrollEnabled = slidingSubviews.count > 1
    }
  }

  open var isAutoSlideEnabled = false {
    didSet {
      self.autoSlideBuffer = self.isAutoSlideEnabled
      if isAutoSlideEnabled {
        startSlide()
      } else {
        pauseSlide()
      }
    }
  }


  // MARK: - Private Properties

  private var appWillResignActiveObserver: NSObjectProtocol!

  private var appDidBecomeActiveObserver: NSObjectProtocol!

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.bounces = false
    return scrollView
  }()

  private var currentViewIndex: Int = 0

  private var currentViewFrame: CGRect = CGRect.zero {
    didSet {
      if slidingSubviews.indices.contains(currentViewIndex) {
        slidingSubviews[currentViewIndex].frame = currentViewFrame
      }
    }
  }

  private var prevViewFrame: CGRect = CGRect.zero

  private var nextViewFrame: CGRect = CGRect.zero

  private var autoSlideBuffer: Bool = false

  private var autoSlideTimer: Timer?

  // MARK: - Methods

  public func setIndex(index: Int) {
    self.currentViewIndex = index
    _ = slidingSubviews.map { view in
      view.isHidden = true
    }
    slidingSubviews[index].isHidden = false
    slidingSubviews[index].frame = currentViewFrame
    scrollView.contentOffset.x = scrollView.frame.width
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setSubviews()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setSubviews()
  }

  convenience public init(frame: CGRect, views: [UIView]) {
    self.init(frame: frame)
    self.slidingSubviews = views
  }

  deinit {
    delegate = nil
    NotificationCenter.default.removeObserver(appWillResignActiveObserver)
    NotificationCenter.default.removeObserver(appDidBecomeActiveObserver)
    self.appWillResignActiveObserver = nil
    self.appDidBecomeActiveObserver = nil
  }

  private func setSubviews() {
    addSubview(scrollView)
    scrollView.delegate = self
    scrollView.frame = self.bounds
    layoutCustomViews()


    appWillResignActiveObserver = NotificationCenter.default.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: OperationQueue.main) { notification in
      self.isAutoSlideEnabled = false

    }

    appDidBecomeActiveObserver = NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main) { notification in
      self.isAutoSlideEnabled = self.autoSlideBuffer
    }

  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    self.layoutCustomViews()
  }

  private func layoutCustomViews() {
    scrollView.frame = self.bounds

    prevViewFrame = CGRect.init(
      origin: CGPoint.init(x: 0.0, y: 0.0),
      size: scrollView.frame.size)

    currentViewFrame = CGRect.init(
      origin: CGPoint.init(x: scrollView.frame.width, y: 0.0),
      size: scrollView.frame.size)

    nextViewFrame = CGRect.init(
      origin: CGPoint.init(x: scrollView.frame.width * 2.0, y: 0.0),
      size: scrollView.frame.size)

    scrollView.contentOffset.x = scrollView.frame.width
    scrollView.contentSize = CGSize.init(
      width: self.bounds.width * 3,
      height: self.bounds.height)

  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    guard slidingSubviews.count > 0 else { return }
    let width = scrollView.frame.width

    // Prepare for slide to next view.
    if scrollView.contentOffset.x > width {
      let nextIndex = (currentViewIndex + 1) % slidingSubviews.count
      let nextView = self.slidingSubviews[nextIndex]
      nextView.frame = nextViewFrame
      nextView.isHidden = false
    }

    // Prepare for slide to previous view.
    if scrollView.contentOffset.x < width {
      let prevIndex = (currentViewIndex + slidingSubviews.count - 1) % slidingSubviews.count
      let prevView = self.slidingSubviews[prevIndex]
      prevView.frame = prevViewFrame
      prevView.isHidden = false
    }

    // Refresh offset
    if scrollView.contentOffset.x >= width * 2.0 {

      // When Completely slided to next view
      let nextIndex = (currentViewIndex + 1) % slidingSubviews.count
      currentViewIndex = nextIndex
      cleanUp()

    } else if scrollView.contentOffset.x <= 0.0 {

      // When Completely slided to previous view.
      let prevIndex = (currentViewIndex + slidingSubviews.count - 1) % slidingSubviews.count
      currentViewIndex = prevIndex
      cleanUp()

    }

    var progress = ((scrollView.contentOffset.x - width) / width) + CGFloat(currentViewIndex)

    if progress < 0 {
      progress += CGFloat(slidingSubviews.count)
    }

    delegate?.sliderDidSlide(self, progress: Double(progress), numberOfViews: slidingSubviews.count, currentViewIndex: currentViewIndex)

  }

  private func startSlide() {
    autoSlideTimer?.invalidate()
    autoSlideTimer = nil
    autoSlideTimer =
      Timer
        .scheduledTimer(
          timeInterval: autoSlideTimeInterval,
          target: self,
          selector: #selector(self.goNextView),
          userInfo: nil,
          repeats: false)
  }


  @objc
  private func goNextView() {
    guard slidingSubviews.count > 0 else { return }
    self.scrollView.setContentOffset(CGPoint.init(x: self.frame.size.width * 2, y: 0.0), animated: true)
  }

  private func hideAll() {
    _ = slidingSubviews.map({ view in
      view.isHidden = true
    })
  }

  private func cleanUp() {
    hideAll()
    slidingSubviews[currentViewIndex].frame = currentViewFrame
    slidingSubviews[currentViewIndex].isHidden = false
    scrollView.contentOffset.x = self.frame.width
    if isAutoSlideEnabled { startSlide() }
  }

  private func pauseSlide() {
  autoSlideTimer?.invalidate()
  autoSlideTimer = nil
  }

}
