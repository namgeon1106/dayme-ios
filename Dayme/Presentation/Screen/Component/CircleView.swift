//
//  CircleView.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit

class CircleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
        layer.cornerCurve = .circular
    }
    
}
