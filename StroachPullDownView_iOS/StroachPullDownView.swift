//
//  StroachPullDownView.swift
//  StroachPullDownView_iOS
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Lukas Trümper
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/**
 
*/
open class StroachPullDownView: UIView {
    
    // MARK: Static variables
    
    private static let threshold: CGFloat = 0.6;
    
    private static var contentOffsetContext = 0;
    
    // MARK: Public properties
    
    ///
    open weak var delegate: AnyObject? {
        willSet {
            if (newValue != nil && !(newValue is StroachPullDownViewDelegate)) {
                fatalError("Value does not conform to delegate.");
            }
        }
    }
    
    ///
    public var isExpanded: Bool {
        get {
            return self.expanded;
        }
        set {
            self.setExpanded(expanded: newValue, animated: false);
        }
    }
    
    ///
    public var bounces: Bool = false;
    
    // MARK: Readonly properties
    
    public private(set) var contentView: UIView;
    
    public private(set) var expandedHeight: CGFloat;
    
    public private(set) var resizedHeight: CGFloat;
    
    // MARK: Private properties
    
    private var scrollView: UIScrollView?;
    
    private var expanded: Bool = false {
        didSet {
            self.delegate?.pullDownViewDidChangeExpansion?(pullDownView: self);
        }
    }
    
    // MARK: Initializer
    
    public init(resizedHeight: CGFloat = 0.0, expandedHeight: CGFloat = 44.0) {
        self.resizedHeight = resizedHeight;
        self.expandedHeight = expandedHeight;
        self.contentView = UIView();
        
        super.init(frame: CGRect.zero);
        
        self.addSubview(self.contentView);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View's lifecycle
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview);
        
        // Remove observer.
        self.scrollView?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), context: &StroachPullDownView.contentOffsetContext);
        self.scrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handlePan(_:)));
        
        if (self.scrollView != nil) {
            let contentInset = self.scrollView!.contentInset;
            self.scrollView!.contentInset = UIEdgeInsetsMake(contentInset.top - (self.isExpanded ? self.expandedHeight : self.resizedHeight), contentInset.left, contentInset.bottom, contentInset.right);
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview();
        
        // Set new superview.
        self.scrollView = self.superview as? UIScrollView;
        
        // Add observer.
        self.scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new], context: &StroachPullDownView.contentOffsetContext);
        self.scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)));
        
        if (self.scrollView != nil) {
            let contentInset = self.scrollView!.contentInset;
            self.scrollView!.contentInset = UIEdgeInsetsMake(contentInset.top + (self.isExpanded ? self.expandedHeight : self.resizedHeight), contentInset.left, contentInset.bottom, contentInset.right);
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        
        self.frame = CGRect(x: 0.0, y: -self.expandedHeight, width: self.scrollView?.bounds.size.width ?? 0.0, height: self.expandedHeight);
        self.contentView.frame = self.bounds;
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &StroachPullDownView.contentOffsetContext) {
            handleScroll();
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context);
        }
    }
    
    // MARK: Handler
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .ended && self.scrollView != nil) {
            let offset = self.scrollView!.contentOffset.y + self.resizedHeight;
            if (offset <= 0.0) {
                if (self.isExpanded) {
                    if (offset > -(self.expandedHeight - self.resizedHeight) * StroachPullDownView.threshold) {
                        self.setExpanded(expanded: false, animated: true);
                    } else {
                        self.scrollView!.setContentOffset(CGPoint(x: 0.0, y: -self.expandedHeight), animated: true);
                    }
                } else {
                    if (offset < -(self.expandedHeight - self.resizedHeight) * StroachPullDownView.threshold) {
                        self.setExpanded(expanded: true, animated: true);
                    }
                }
            }
        }
    }
    
    private func handleScroll() {
        if (self.scrollView == nil) { return; }
        
        let offset = self.scrollView!.contentOffset.y + self.resizedHeight;
        
        if (offset < 0.0) {
            let offsetInPercent = -offset / (self.expandedHeight - self.resizedHeight);

            handleAnimation(offsetInPercent: offsetInPercent);
            
            if (offsetInPercent > 1.0 && !self.bounces) {
                self.scrollView!.contentOffset = CGPoint(x: 0.0, y: -self.expandedHeight);
            }
        } else if (offset >= 0.0 && self.expanded) {
            self.isExpanded = false;
        }
    }
    
    /**
     
     */
    open func handleAnimation(offsetInPercent: CGFloat) {
        
    }
    
    // MARK: Public functions
    
    /**
 
    */
    public func setExpanded(expanded: Bool, animated: Bool) {
        if (self.isExpanded != expanded) {
            self.expanded = expanded;
            
            if (self.scrollView != nil) {
                let contentInset = self.scrollView!.contentInset;
                if (expanded) {
                    self.scrollView!.contentInset = UIEdgeInsetsMake(contentInset.top + (self.expandedHeight - self.resizedHeight), contentInset.left, contentInset.bottom, contentInset.right);
                    
                    self.scrollView!.setContentOffset(CGPoint(x: 0.0, y: -self.expandedHeight), animated: animated);
                } else {
                    self.scrollView!.contentInset = UIEdgeInsetsMake(contentInset.top - (self.expandedHeight - self.resizedHeight), contentInset.left, contentInset.bottom, contentInset.right);
                }
            }
        }
    }
    
}


/**
 
*/
@objc public protocol StroachPullDownViewDelegate: class {
    
    @objc optional func pullDownViewDidChangeExpansion(pullDownView: StroachPullDownView);
    
}
