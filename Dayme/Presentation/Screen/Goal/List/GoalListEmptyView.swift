//
//  GoalListEmptyView.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import UIKit

protocol GoalListEmptyViewDelegate: AnyObject {
    func goalListEmptyViewDidTapAddGoal()
}

final class GoalListEmptyView: Vue {
    
    weak var delegate: GoalListEmptyViewDelegate?
    
    // MARK: UI properties
    
    private let messageLbl = UILabel("첫 목표를 생성해보세요 !").then {
        $0.textColor(.colorGrey50).font(.pretendard(.medium, 16))
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
        config.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        $0.configuration = config
    }
    
    
    // MARK: Helpers
    
    override func setupAction() {
        addBtn.onAction { [weak self] in
            self?.delegate?.goalListEmptyViewDidTapAddGoal()
        }
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.alignItems(.center).justifyContent(.center).paddingBottom(30).define { flex in
            flex.addItem(messageLbl)
            
            flex.addItem(addBtn).marginTop(12).height(40)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
}
