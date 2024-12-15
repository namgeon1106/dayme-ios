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
        let insets = UIEdgeInsets(8, 12)
        contentView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: insets.top),
            titleLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: insets.left),
            titleLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -insets.right),
            titleLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -insets.bottom),
        ])
    }
    
    func update(category: String, isSelected: Bool) {
        titleLbl.text = category
        titleLbl.textColor = isSelected ? .colorMain1 : .colorDark100
        layer.borderColor = .uiColor(isSelected ? .colorMain1 : .colorGrey20)
    }
    
}
