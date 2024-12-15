//
//  CollectionViewCell.swift
//  Dayme
//
//  Created by 정동천 on 12/15/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let flexView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupAction()
        setupFlex()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutFlex()
    }
    
    // MARK: - Helpers
    
    func setup() {}
    func setupAction() {}
    func setupFlex() {}
    func layoutFlex() {}
    
}
