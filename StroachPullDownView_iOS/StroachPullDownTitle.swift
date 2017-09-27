//
//  StroachPullDownTitle.swift
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
open class StroachPullDownTitle: StroachPullDownBar {
    
    // MARK: Public properties
    
    open override weak var delegate: AnyObject? {
        willSet {
            if (newValue != nil && !(newValue is StroachPullDownTitleDelegate)) {
                fatalError("Value does not conform to delegate.");
            }
        }
    }
    
    ///
    public var title: String? {
        get {
            return self.titleButton.title(for: .normal);
        }
        set {
            self.titleButton.setTitle(newValue, for: .normal);
            self.titleButton.isHidden = (newValue == nil);
        }
    }
    
    ///
    public var titleColor: UIColor {
        get {
            return self.titleButton.tintColor;
        }
        set {
            self.titleButton.tintColor = newValue;
        }
    }
    
    ///
    public var titleFont: UIFont {
        get {
            return self.titleButton.titleLabel!.font;
        }
        set {
            return self.titleButton.titleLabel!.font = newValue;
        }
    }
    
    // MARK: Private properties
    
    private var titleButton: UIButton;
    
    // MARK: Initializer
    
    public init(title: String?, leftAccessoryImage: UIImage?, rightAccessoryImage: UIImage?) {
        self.titleButton = UIButton(type: .system);
        
        super.init(titleView: self.titleButton, leftAccessoryImage: leftAccessoryImage, rightAccessoryImage: rightAccessoryImage);
        
        self.title = title;
        self.titleButton.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Handler
    
    @objc open override func handleButtons(_ sender: UIButton) {
        super.handleButtons(sender);
        
        switch sender {
        case self.titleButton:
            if let del = self.delegate as? StroachPullDownTitleDelegate {
                del.pullDownViewDidTapOnTitleButton?(pullDownView: self);
            }
            break;
        default:
            break;
        }
    }
    
}

@objc public protocol StroachPullDownTitleDelegate: StroachPullDownBarDelegate {
    
    @objc optional func pullDownViewDidTapOnTitleButton(pullDownView: StroachPullDownTitle);
    
}
