//
//  UICollectionView++.swift
//  Dayme
//
//  Created by 정동천 on 12/15/24.
//

import UIKit

extension UICollectionViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Error: Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
}
