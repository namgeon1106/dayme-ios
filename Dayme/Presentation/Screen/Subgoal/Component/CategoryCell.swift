//
//  CategoryCell.swift
//  Dayme
//
//  Created by 정동천 on 12/15/24.
//

import UIKit

final class CategoryCell: CollectionViewCell {
    
    let titleLbl = UILabel().then {
        $0.textColor(.colorDark70).font(.pretendard(.medium, 14))
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    override func setup() {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = .uiColor(.colorGrey20)
    }
    
    override func setupFlex() {
        contentView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func update(category: String, isSelected: Bool) {
        titleLbl.text = category
        titleLbl.textColor = isSelected ? .colorMain1 : .colorDark100
        layer.borderColor = .uiColor(isSelected ? .colorMain1 : .colorGrey20)
    }
    
}
