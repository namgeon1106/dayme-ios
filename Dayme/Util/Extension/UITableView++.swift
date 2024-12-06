//
//  UITableView++.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        self.register(cellType, forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
}
