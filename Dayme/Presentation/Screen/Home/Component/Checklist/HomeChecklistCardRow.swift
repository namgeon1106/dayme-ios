//
//  HomeChecklistCardRow.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit
import FlexLayout
import PinLayout

typealias RowItem = (goal: Goal, checklist: Checklist)

protocol HomeChecklistCardRowDelegate: AnyObject {
    func homeChecklistCardRowDidCheck(goal: Goal, checklist: Checklist)
}

final class HomeChecklistCardRow: Vue {
    
    weak var delegate: HomeChecklistCardRowDelegate?
    
    let item: RowItem
    
    // MARK: UI properties
    
    private let titleLabel = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 13))
    }
    
    private lazy var checkButton = UIButton().then {
        let isCompleted = item.checklist.isCompleted
        $0.setImage(isCompleted ? .icCheckOnDark : .icCheckOff, for: .normal)
    }
    
    
    // MARK: Lifecycles
    
    init(item: RowItem) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        titleLabel.text = item.checklist.title
        
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem().width(3).height(16).backgroundColor(.hex(item.goal.hex))
            
            flex.addItem(titleLabel).marginLeft(6).grow(1)
            
            flex.addItem(checkButton)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    override func setupAction() {
        checkButton.onAction { [weak self] in
            guard let self else { return }
            delegate?.homeChecklistCardRowDidCheck(goal: item.goal, checklist: item.checklist)
        }
    }
    
}
