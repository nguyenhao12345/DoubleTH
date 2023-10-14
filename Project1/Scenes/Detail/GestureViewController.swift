//
//  GestureViewController.swift
//  Project1
//
//  Created by VO ANH TRUONG on 14/10/2023.
//

import UIKit

class GestureViewController: UIViewController {
    var image: UIImage?
    
    var originalImageCenter: CGPoint?
    var isZooming = false
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard are a pain")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //        setupImageView()
        
        if let image = image {
            let imageView = ImageZoomView(frame: UIScreen.main.bounds, image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 5
            view.addSubview(imageView)
        }
    }
}

// MARK: - Setup window
extension GestureViewController {
    static private let window: UIWindow = {
        let window = UIWindow()
        window.windowLevel = UIWindow.Level.normal
        let empty = UIViewController()
        empty.view.backgroundColor = UIColor.black.withAlphaComponent(1)
        window.rootViewController = empty
        window.backgroundColor = .clear
        return window
    }()
    
    class func show(image: UIImage) {
        dismiss()
        let viewController = GestureViewController(image: image)
        viewController.view.frame = UIScreen.main.bounds
        viewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            window.makeKeyAndVisible()
            window.rootViewController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    class func dismiss() {
        window.isHidden = true
        if(window.rootViewController?.presentedViewController != nil) {
            window.rootViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - Image Zoom

class ImageZoomView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView!
    var gestureRecognizer: UITapGestureRecognizer!
    
    convenience init(frame: CGRect, image: UIImage?) {
        self.init(frame: frame)
        
        var imageToUse: UIImage
        
        if let image = image {
            imageToUse = image
        } else {
            fatalError("No image was passed in and failed to find an image at the path.")
        }
        
        imageView = UIImageView(image: imageToUse)
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let const:[NSLayoutConstraint] = [
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(const)
        
        setupScrollView(image: imageToUse)
        setupGestureRecognizer()
    }
    
    func setupScrollView(image: UIImage) {
        delegate = self
        
        minimumZoomScale = 1.0
        maximumZoomScale = 2.0
    }
    
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                GestureViewController.dismiss()
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
