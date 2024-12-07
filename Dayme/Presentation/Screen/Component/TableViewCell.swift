//
//  TableViewCell.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let flexView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
