//
//  StroachPullDownBar.swift
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
open class StroachPullDownBar: StroachPullDownView {
    
    // MARK: Static variables
    
    private static let defaultPadding: CGFloat = 10.0;
   
    // MARK: Public properties
    
    ///
    open override weak var delegate: AnyObject? {
        willSet {
            if (newValue != nil && !(newValue is StroachPullDownBarDelegate)) {
                fatalError("Value does not conform to delegate.");
            }
        }
    }
    
    ///
    public var leftAccessoryImage: UIImage? {
        get {
            return self.leftAccessoryButton.image(for: .normal);
        }
        set {
            self.leftAccessoryButton.setImage(newValue, for: .normal);
            self.leftAccessoryButton.isHidden = (newValue == nil);
        }
    }
    
    ///
    public var rightAccessoryImage: UIImage? {
        get {
            return self.rightAccessoryButton.image(for: .normal);
        }
        set {
            self.rightAccessoryButton.setImage(newValue, for: .normal);
            self.rightAccessoryButton.isHidden = (newValue == nil);
        }
    }
    
    // MARK: Private properties
    
    private var titleView: UIView?;
    
    private var leftAccessoryButton: UIButton;
    
    private var rightAccessoryButton: UIButton;
    
    // MARK: Initializer
    
    public init(titleView: UIView?, leftAccessoryImage: UIImage?, rightAccessoryImage: UIImage?) {
        self.titleView = titleView;
        self.leftAccessoryButton = UIButton(type: .system);
        self.rightAccessoryButton = UIButton(type: .system);
        
        super.init();
        
        if (self.titleView != nil) {
            self.contentView.addSubview(self.titleView!);
        }
        
        self.leftAccessoryImage = leftAccessoryImage;
        self.leftAccessoryButton.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside);
        self.contentView.addSubview(self.leftAccessoryButton);
        
        self.rightAccessoryImage = rightAccessoryImage;
        self.rightAccessoryButton.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside);
        self.contentView.addSubview(self.rightAccessoryButton);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View's lifecycle
    
    open override func layoutSubviews() {
        super.layoutSubviews();
        
        self.leftAccessoryButton.frame = CGRect(x: StroachPullDownBar.defaultPadding, y: StroachPullDownBar.defaultPadding, width: self.contentView.bounds.size.height - StroachPullDownBar.defaultPadding * 2.0, height: self.contentView.bounds.size.height - StroachPullDownBar.defaultPadding * 2.0);
        self.rightAccessoryButton.frame = self.leftAccessoryButton.frame;
        self.rightAccessoryButton.frame.origin.x = self.contentView.bounds.size.width - StroachPullDownBar.defaultPadding - self.rightAccessoryButton.bounds.size.width;
        
        self.titleView?.frame = self.contentView.bounds.insetBy(dx: self.leftAccessoryButton.frame.maxX + StroachPullDownBar.defaultPadding * 0.75 * 2.0, dy: StroachPullDownBar.defaultPadding * 0.75);
    }
    
    // MARK: Handler
    
    open override func handleAnimation(offsetInPercent: CGFloat) {
        super.handleAnimation(offsetInPercent: offsetInPercent);
        
        self.contentView.alpha = offsetInPercent;
    }
    
    @objc open func handleButtons(_ sender: UIButton) {
        switch sender {
        case self.leftAccessoryButton:
            if let del = self.delegate as? StroachPullDownBarDelegate {
                del.pullDownViewDidTapOnLeftAccessoryButton?(pullDownView: self);
            }
            break;
        case self.rightAccessoryButton:
            if let del = self.delegate as? StroachPullDownBarDelegate {
                del.pullDownViewDidTapOnRightAccessoryButton?(pullDownView: self);
            }
            break;
        default:
            break;
        }
    }
    
}

@objc protocol StroachPullDownBarDelegate: StroachPullDownViewDelegate {
    
    @objc optional func pullDownViewDidTapOnLeftAccessoryButton(pullDownView: StroachPullDownBar);
    
    @objc optional func pullDownViewDidTapOnRightAccessoryButton(pullDownView: StroachPullDownBar);
    
}

