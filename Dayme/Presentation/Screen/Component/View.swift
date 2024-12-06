//
//  View.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

class Vue: UIView {
    
    var isCircleRadius: Bool = false
    
    let flexView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupAction()
        setupFlex()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFlex()
        
        if isCircleRadius {
            layer.cornerRadius = bounds.height / 2
            layer.cornerCurve = .circular
        }
    }
    
    // MARK: - Helpers
    
    func setup() {}
    func setupAction() {}
    func setupFlex() {}
    func layoutFlex() {}
    func bind() {}
    
}
