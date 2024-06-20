//
//  FullscreenImageViewController.swift
//  Accounting
//
//  Created by Марк Кулик on 20.06.2024.
//

//import UIKit
//
//class FullscreenImageViewController: UIViewController, UIScrollViewDelegate {
//    
//    let scrollView = UIScrollView()
//    let imageView = UIImageView()
//    var image: UIImage
//    
//    init(image: UIImage) {
//        self.image = image
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        
//        imageView.image = image
//        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
//        imageView.isUserInteractionEnabled = true
//        
//        scrollView.delegate = self
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 3.0
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.addSubview(imageView)
//        view.addSubview(scrollView)
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        scrollView.addGestureRecognizer(tapGesture)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
//        imageView.frame = scrollView.bounds
//    }
//    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageView
//    }
//    
//    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        dismiss(animated: true, completion: nil)
//    }
//}

import UIKit

class FullscreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    var imageViews: [UIImageView] = []
    var currentIndex: Int = 0
    
    init(images: [UIImage], initialIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.currentIndex = initialIndex
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageViews.append(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 3.0
        view.addSubview(scrollView)
        
        for (index, imageView) in imageViews.enumerated() {
            let scrollViewFrame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
            let imageScrollView = UIScrollView(frame: scrollViewFrame)
            imageScrollView.delegate = self
            imageScrollView.minimumZoomScale = 1.0
            imageScrollView.maximumZoomScale = 3.0
            imageScrollView.showsVerticalScrollIndicator = false
            imageScrollView.showsHorizontalScrollIndicator = false
            
            imageView.frame = imageScrollView.bounds
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x: imageScrollView.bounds.midX, y: imageScrollView.bounds.midY)
            
            imageScrollView.addSubview(imageView)
            scrollView.addSubview(imageScrollView)
            
            // Изменение на двойное нажатие
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTapGesture)
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imageViews.count), height: view.frame.height)
        scrollView.contentOffset = CGPoint(x: view.frame.width * CGFloat(currentIndex), y: 0)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if newIndex != currentIndex {
            currentIndex = newIndex
            resetZoomForImageScrollViews()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        for (index, imageScrollView) in scrollView.subviews.enumerated() {
            if let imageScrollView = imageScrollView as? UIScrollView {
                imageScrollView.frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)
                
                if let imageView = imageScrollView.subviews.first as? UIImageView {
                    imageView.center = CGPoint(x: imageScrollView.bounds.midX, y: imageScrollView.bounds.midY)
                }
            }
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(imageViews.count), height: view.frame.height)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let imageView = scrollView.subviews.first as? UIImageView {
            return imageView
        }
        return nil
    }
    
    // MARK: - Gesture Recognizer
    
    @objc func handleDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let imageScrollView = gesture.view?.superview as? UIScrollView else { return }
        
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            let location = gesture.location(in: imageScrollView)
            let zoomRect = zoomRectForScale(scale: imageScrollView.maximumZoomScale, center: location)
            imageScrollView.zoom(to: zoomRect, animated: true)
        } else {
            imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: scrollView.frame.size.width / scale, height: scrollView.frame.size.height / scale)
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        return CGRect(origin: origin, size: size)
    }
    
    private func resetZoomForImageScrollViews() {
        for case let imageScrollView as UIScrollView in scrollView.subviews {
            imageScrollView.zoomScale = 1.0
        }
    }

}

