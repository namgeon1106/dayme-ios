//
//  CategoryPopup.swift
//  Dayme
//
//  Created by 정동천 on 12/15/24.
//

import UIKit

final class CategoryPopup: UIAlertController {
    
    var continuation: CheckedContinuation<String?, Never>?
    var textField: UITextField!
    
    static func show(on viewController: UIViewController, animated: Bool = true) async -> String? {
        return await withCheckedContinuation { continuation in
            let alert = CategoryPopup(
                title: "세부목표 추가",
                message: "카테고리",
                preferredStyle: .alert
            )
            alert.setup()
            alert.continuation = continuation
            
            viewController.present(alert, animated: animated)
        }
    }

    private func setup() {
        addTextField { [weak self] textField in
            textField.placeholder = "새로운 카테고리를 입력하세요"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.clearButtonMode = .whileEditing
            self?.textField = textField
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.continuation?.resume(returning: self?.textField.text)
        }
        confirmAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.continuation?.resume(returning: nil)
        }
        
        textField.addAction(UIAction { [weak self] _ in
            confirmAction.isEnabled = !(self?.textField.text ?? "").isEmpty
        }, for: .editingChanged)
        
        addAction(confirmAction)
        addAction(cancelAction)
    }
    
}

