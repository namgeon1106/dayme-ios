//
//  GoalListEmptyView.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import UIKit

protocol GoalListEmptyViewDelegate: AnyObject {
    func didTapAddButton()
}

final class GoalListEmptyView: Vue {
    
    weak var delegate: GoalListEmptyViewDelegate?
    
    // MARK: UI properties
    
    private let messageLbl = UILabel("첫 목표를 설정해 보세요 !").then {
        $0.textColor(.colorGrey50).font(.pretendard(.medium, 15))
    }
    
    private let addBtn = UIButton().then {
        var config = UIButton.Configuration.filled()
        var attributes = AttributeContainer()
        attributes.font = UIFont.pretendard(.semiBold, 16)
        let title = AttributedString("목표 만들기", attributes: attributes)
        config.attributedTitle = title
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.image = image
        config.imagePadding = 4
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .colorDark100
        config.contentInsets = .init(top: 0, leading: 56, bottom: 0, trailing: 56)
        $0.configuration = config
    }
    
    
    // MARK: Helpers
    
    override func setupAction() {
        addBtn.onAction { [weak self] in
            self?.delegate?.didTapAddButton()
        }
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.alignItems(.center).justifyContent(.center).define { flex in
            flex.addItem(messageLbl).height(23)
            
            flex.addItem(addBtn).marginTop(12).height(50)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
}
