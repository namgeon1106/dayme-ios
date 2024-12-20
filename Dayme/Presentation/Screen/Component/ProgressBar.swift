//
//  ProgressBar.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit
import FlexLayout
import PinLayout

final class ProgressBar: Vue {
    
    var progress: CGFloat = 0 {
        didSet {
            percentLabel.text = String(format: "%.0f%%달성", progress * 100)
            setNeedsLayout()
        }
    }
    
    var showIndicator: Bool = false {
        didSet { percentLabel.alpha = showIndicator ? 1 : 0 }
    }
    
    override var tintColor: UIColor! {
        get { bar.backgroundColor }
        set { bar.backgroundColor = newValue }
    }
    
    private let bar = Vue()
    private let percentLabel = UILabel().then {
        $0.textColor(.white).font(.pretendard(.regular, 12))
        $0.alpha = 0
    }
    
    override func setup() {
        backgroundColor = .colorDarkA10
        isCircleRadius = true
        bar.isCircleRadius = true
    }
    
    override func setupFlex() {
        addSubview(bar)
        bar.addSubview(percentLabel)
    }
    
    override func layoutFlex() {
        let width = bounds.width * progress
        bar.pin.top().left().bottom().width(width)
        percentLabel.sizeToFit()
        percentLabel.pin.center()
    }
    
}
