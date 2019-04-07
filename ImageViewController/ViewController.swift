//
//  ViewController.swift
//  SampleProject
//
//  Created by Divya Mandyam on 3/25/19.
//  Copyright © 2019 Divya Mandyam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private static let maximumZoomScale = 3.0
    
    let image: UIImage?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        image = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollViewFrame()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupScrollViewFrame()
    }
    
    private func setupScrollViewFrame() {
        guard let image = image else {
            return
        }
        
        let updatedSize = getUpdatedImageSize(image.size)
        
        let yOffset: CGFloat
        let xOffset: CGFloat
        if UIApplication.shared.statusBarOrientation.isLandscape {
            xOffset = (view.bounds.width - updatedSize.width) / 2.0
            yOffset = 0
        } else {
            xOffset = 0
            yOffset = (view.bounds.height - updatedSize.height) / 2.0
        }
        
        scrollView.frame = CGRect(x: xOffset, y: yOffset, width: updatedSize.width, height: updatedSize.height)
        imageView.frame = CGRect(x: 0, y: 0, width: updatedSize.width, height: updatedSize.height)
        updateZoomScale()
        
        centerImageView()
    }
    
    
    private func updateZoomScale() {
        let widthScale = scrollView.bounds.width / imageView.bounds.width
        let heightScale = scrollView.bounds.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = minScale
    }
    
    private func getUpdatedImageSize(_ size: CGSize) -> CGSize {
        /** We are using the formula oldWidth/newWidth = oldHeight/newHeight...newHeight = (newWidth/oldWidth) * oldHeight **/
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        newHeight = (view.bounds.width / size.width) * size.height
        newWidth = (view.bounds.height / size.height) * size.width
        
        if newWidth > view.bounds.width {
            newWidth = view.bounds.width
        } else {
            newHeight = view.bounds.height
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollViewFrame()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
    }
    
    private func centerImageView() {
        var imageViewFrame = imageView.frame
        let scrollViewFrame = scrollView.frame
        
        if imageViewFrame.width < scrollViewFrame.width {
            imageViewFrame.origin.x = (scrollViewFrame.width - imageViewFrame.width) / 2
        } else {
            imageViewFrame.origin.x = 0
        }
        
        if imageViewFrame.height < scrollViewFrame.height {
            imageViewFrame.origin.y = (scrollViewFrame.height - imageViewFrame.height) / 2
        } else {
            imageViewFrame.origin.y = 0
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
}

