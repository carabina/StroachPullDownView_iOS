//
//  StroachPullDownSegments.swift
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
open class StroachPullDownSegments: StroachPullDownBar {

    // MARK: Public properties
    
    ///
    open override weak var delegate: AnyObject? {
        willSet {
            if (newValue != nil && !(newValue is StroachPullDownSegmentsDelegate)) {
                fatalError("Value does not conform to delegate.");
            }
        }
    }

    ///
    public var selectedSegmentIndex: Int {
        get {
            return self.segmentedControl.selectedSegmentIndex;
        }
        set {
            self.segmentedControl.selectedSegmentIndex = newValue;
        }
    }
    
    // MARK: Private properties
    
    private var segmentedControl: UISegmentedControl;
    
    // MARK: Initializer
    
    public init(items: [Any]?, leftAccessoryImage: UIImage?, rightAccessoryImage: UIImage?) {
        self.segmentedControl = UISegmentedControl(items: items);
        
        super.init(titleView: self.segmentedControl, leftAccessoryImage: leftAccessoryImage, rightAccessoryImage: rightAccessoryImage);
        
        self.selectedSegmentIndex = 0;
        self.segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged);
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Handler
    
    @objc private func handleSegmentedControl(_ sender: UISegmentedControl) {
        if (sender == self.segmentedControl) {
            if let del = delegate as? StroachPullDownSegmentsDelegate {
                del.pullDownViewDidSelectSegment?(pullDownView: self, AtIndex: sender.selectedSegmentIndex);
            }
        }
    }
    
}

@objc public protocol StroachPullDownSegmentsDelegate: StroachPullDownBarDelegate {
    
    @objc optional func pullDownViewDidSelectSegment(pullDownView: StroachPullDownSegments, AtIndex index: Int);
    
}
