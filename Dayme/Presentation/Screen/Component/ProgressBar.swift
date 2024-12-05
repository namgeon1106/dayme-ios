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
        didSet { setNeedsLayout() }
    }
    
    override var tintColor: UIColor! {
        get { bar.backgroundColor }
        set { bar.backgroundColor = newValue }
    }
    
    private let bar = Vue()
    
    override func setup() {
        backgroundColor = .colorDarkA10
        isCircleRadius = true
        bar.isCircleRadius = true
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem(bar).grow(1)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        bar.pin.height(flexView.bounds.height)
        let width = flexView.bounds.width * progress
        bar.pin.top().left().bottom().width(width)
    }
    
}
