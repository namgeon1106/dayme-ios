//
//  SubgoalSection.swift
//  Dayme
//
//  Created by 정동천 on 12/13/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview(traits: .fixedLayout(width: 375, height: 244)) {
    let section = SubgoalSection()
    let subgoals = Array(1...10).flatMap { _ in mockSubgoals }
    section.update(subgoals: subgoals)
    return section
}
#endif

protocol SubgoalSectionDelegate: AnyObject {
    func subgoalSectionDidTapAddButton()
}

final class SubgoalSection: Vue {
    
    weak var delegate: SubgoalSectionDelegate?
    
    private(set) var subgoals: [Subgoal] = []
    
    // MARK: - UI properties
    
    private let container = UIView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let subgoalSubtitleLbl = UILabel("세부목표").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    
    private let emptyLbl = UILabel().then {
        $0.text("세부 목표가 설정되지 않았어요.\n세부 목표를 작성하고 목표를 관리해보세요!")
            .textColor(.colorGrey50)
            .textAlignment(.center)
            .font(.pretendard(.regular, 14))
            .numberOfLines(2)
            .lineHeight(multiple: 1.2)
    }
    
    private let addWithValueBtn = UIButton().then {
        var config = UIButton.Configuration.filled()
        var attrString = AttributedString("세부목표 추가하기")
        attrString.font = UIFont.pretendard(.medium, 12)
        config.attributedTitle = attrString
        config.baseForegroundColor = .colorDark100
        config.baseBackgroundColor = .colorBackground
        config.background.cornerRadius = 4
        config.background.strokeWidth = 1
        config.background.strokeColor = .colorGrey20
        $0.configuration = config
    }
    private let addNoValueBtn = FilledSecondaryButton("세부목표 작성하기")
    
    
    // MARK: Helpers
    
    override func setup() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(0, 20)
    }
    
    override func setupAction() {
        [addWithValueBtn, addNoValueBtn].forEach { button in
            button.onAction { [weak self] in
                self?.delegate?.subgoalSectionDidTapAddButton()
            }
        }
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem(subgoalSubtitleLbl).margin(24, 24, 8, 0)
            
            flex.addItem(container).define { flex in
                flex.addItem().height(194)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
        scrollView.contentSize = contentView.bounds.size
    }
    
    
    func update(subgoals: [Subgoal]) {
        self.subgoals = subgoals
        
        container.flex.isIncludedInLayout = false
        
        [container, scrollView, contentView]
            .flatMap(\.subviews)
            .forEach { $0.removeFromSuperview() }
        
        if subgoals.isEmpty {
            container.flex.define { flex in
                flex.addItem().alignItems(.center).justifyContent(.center).height(194).define { flex in
                    flex.addItem(emptyLbl)
                    
                    flex.addItem(addNoValueBtn).margin(8, 0, 20, 0)
                }
            }
        } else {
            container.flex.define { flex in
                flex.addItem(scrollView).grow(1).define { flex in
                    flex.addItem(contentView).direction(.row).define { flex in
                        subgoals.map(SubgoalCard.init).forEach {
                            flex.addItem($0).width(152).height(164).marginHorizontal(4)
                        }
                    }
                }
                
                flex.addItem(addWithValueBtn).height(36).margin(14, 24, 24)
            }
        }
        
        container.flex.isIncludedInLayout = true
        setNeedsLayout()
    }
    
}
