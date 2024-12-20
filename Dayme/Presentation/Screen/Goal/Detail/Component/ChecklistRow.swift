//
//  ChecklistRow.swift
//  Dayme
//
//  Created by 정동천 on 12/20/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview(traits: .fixedLayout(width: 327, height: 52)) {
    ChecklistRow(item: (goalTitle: mockGoals[0].title, checklist: mockChecklists[0]))
}
#endif

protocol ChecklistRowDelegate: AnyObject {
    func checklistRowDidTapCheck(_ checklist: Checklist)
}

typealias ChecklistItem = (goalTitle: String, checklist: Checklist)

final class ChecklistRow: Vue {
    
    weak var delegate: ChecklistRowDelegate?
    
    private(set) var item: ChecklistItem
    
    // MARK: UI properties
    
    private lazy var checkButton = UIButton().then {
        let isCompleted = item.checklist.isCompleted
        $0.setImage(isCompleted ? .icCheckOn : .icCheckOff, for: .normal)
    }
    
    private let topGoalLabel = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.regular, 12))
        $0.numberOfLines(1)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 14))
        $0.numberOfLines(1)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    
    // MARK: Lifecycles
    
    init(item: ChecklistItem) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        backgroundColor = .colorGrey10
        layer.cornerRadius = 12
        topGoalLabel.text = item.goalTitle
        titleLabel.text = item.checklist.title
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.direction(.row).alignItems(.center).define { flex in
            flex.addItem(checkButton).marginLeft(2).width(44).height(44)
            
            flex.addItem().define { flex in
                flex.addItem(topGoalLabel)
                flex.addItem(titleLabel).marginTop(4)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    override func setupAction() {
        checkButton.onAction { [weak self] in
            guard let self else { return }
            delegate?.checklistRowDidTapCheck(item.checklist)
        }
    }
    
}
