//
//  AlbumCollectionViewCell.swift
//  Project1
//
//  Created by NguyenHao on 12/10/2023.
//

import UIKit

final class AlbumCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var subSelectionView: UIView!
    
    var doubleTapBlock: (() -> Void)?
    
    override func awakeFromNib() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        imageView.addGestureRecognizer(pinch)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    
    func config(with title: String, image: UIImage) {
        imageView.image = image
    }
    
    override func setupView() {
        //        DispatchQueue.main.async {
        ////            self.selectionView.layer.cornerRadius = self.selectionView.bounds.size.width/2
        ////            self.selectionView.layer.masksToBounds = true
        //            self.selectionView.setRounded()
        //        }
        
    }
    
    @objc private func pinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale * sender.scale
            if newScale > 1 {
                GestureViewController.show(image: UIImage(named: "Image")!)
            }
        default:
            break
        }
    }
    
    @objc func handleDoubleTap() {
        doubleTapBlock?()
    }
}

extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowOffset : CGSize{
        
        get{
            return layer.shadowOffset
        }set{
            
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set {
            
            layer.shadowOpacity = newValue
            
        }
    }
    
    @IBInspectable
    var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable
    var shadowSpread: CGFloat {
        get {
            return layer.shadowPath as! CGFloat
        }
        set {
            let dx = -newValue
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCornerByAddLayer(corners: CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    
    func setRadius(_ equal: CGFloat) {
        layer.cornerRadius = equal
        layer.masksToBounds = true
    }
    
    func addTapGesture(_ target: Any?, _ selector: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    func addLongPressGesture(_ target: Any?, _ selector: Selector) {
        let longPressedGesture = UILongPressGestureRecognizer(target: target, action: selector)
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delaysTouchesBegan = true
        addGestureRecognizer(longPressedGesture)
    }
    
    func setupBorder(borderColor: UIColor, offSet: CGSize = .zero, opacity: Float = 0, shadowRadius: CGFloat = 0, borderWidth: CGFloat, shadowColor: UIColor = .clear) {
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
    }
    
    func fillVerticalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            //                if #available(iOS 11, *) {
            //                    topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            //                    bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
            //                } else {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            //                }
            
        }
    }
    
    func fillHorizontalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            //                if #available(iOS 11, *) {
            //                    leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
            //                    rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
            //                } else {
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
            //}
        }
    }
    
    func addBlur(alpha:CGFloat){
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.alpha = alpha
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func setRounded() {
        let radius = CGRectGetWidth(self.frame) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
