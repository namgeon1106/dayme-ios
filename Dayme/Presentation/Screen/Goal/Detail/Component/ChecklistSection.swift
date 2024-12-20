//
//  ChecklistSection.swift
//  Dayme
//
//  Created by 정동천 on 12/19/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview(traits: .fixedLayout(width: 375, height: 454)) {
    let section = ChecklistSection(goal: mockGoals[0])
    section.update(goal: mockGoals[0])
    return section
}
#endif

protocol ChecklistSectionDelegate: AnyObject {
    func checklistSectionDidTapAddButton(subgoal: Subgoal?)
    func checklistSectionDidTapEditButton(_ checklist: Checklist)
    func checklistSectionDidTapSeeMoreButton()
}

final class ChecklistSection: Vue {
    
    weak var delegate: ChecklistSectionDelegate?
    
    private var goal: Goal
    /// 전체 체크리스트 더보기 선택 여부
    private var isSeeMoreSelected: Bool = false
    
    // MARK: - UI properties
    
    private let container = UIView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let subgoalSubtitleLbl = UILabel("체크리스트").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    
    private let emptyLbl = UILabel().then {
        $0.text("체크리스트가 설정되지 않았어요.\n체크리스트를 작성하고 목표를 관리해보세요!")
            .textColor(.colorGrey50)
            .textAlignment(.center)
            .font(.pretendard(.regular, 14))
            .numberOfLines(2)
            .lineHeight(multiple: 1.2)
    }
    
    private let addNoValueBtn = FilledSecondaryButton("체크리스트 작성하기")
    private let addWithValueBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseForegroundColor = .colorGrey30
        $0.configuration = config
    }
    private let seeMoreButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        var attrString = AttributedString("더보기")
        attrString.font = UIFont.pretendard(.medium, 12)
        config.attributedTitle = attrString
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
        config.image = .icChevronDown
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.baseForegroundColor = .colorDark100
        config.baseBackgroundColor = .colorBackground
        config.background.cornerRadius = 4
        config.background.strokeWidth = 1
        config.background.strokeColor = .colorGrey20
        $0.configuration = config
    }
    
    private lazy var tabAllButton = tabButton(tag: 0, title: "전체")
    private lazy var tabSubgoalsButton = tabButton(tag: 1, title: "세부목표별")
    
    private var tabButtons: [UIButton] {
        [tabAllButton, tabSubgoalsButton]
    }
    
    
    // MARK: - Lifecycle
    
    init(goal: Goal) {
        self.goal = goal
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    override func setup() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(0, 20)
        selectTab(tag: 0)
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(subgoalSubtitleLbl).margin(24, 24, 8, 0)
                
                flex.addItem().grow(1)
                
                flex.addItem(addWithValueBtn).margin(10, 0, 0, 6)
            }
            
            flex.addItem().direction(.row).height(30).define { flex in
                flex.addItem(tabAllButton).margin(4, 24, 0, 0)
                
                flex.addItem(tabSubgoalsButton).marginLeft(6)
            }
            
            flex.addItem(container).marginTop(8).define { flex in
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
    
    override func setupAction() {
        [addNoValueBtn, addWithValueBtn].forEach { button in
            button.onAction { [weak self] in
                guard let self else { return }
                delegate?.checklistSectionDidTapAddButton(subgoal: nil)
            }
        }
        
        seeMoreButton.onAction { [weak self] in
            self?.isSeeMoreSelected = true
            self?.update()
            self?.delegate?.checklistSectionDidTapSeeMoreButton()
        }
    }
    
    
    func update(goal: Goal? = nil) {
        let goal = goal ?? self.goal
        self.goal = goal
        
        container.flex.isIncludedInLayout = false
        
        [container, scrollView, contentView]
            .flatMap(\.subviews)
            .forEach { $0.removeFromSuperview() }
        
        let goalChecklistItem: [ChecklistItem] = goal.checklists.map { (goal.title, $0) }
        let subgoalChecklistItem: [ChecklistItem] = goal.subgoals.flatMap { subgoal in
            return subgoal.checklists.map { (subgoal.title, $0) }
        }
        let allChecklistsItem = goalChecklistItem + subgoalChecklistItem
        
        if allChecklistsItem.isEmpty {
            container.flex.define { flex in
                flex.addItem().alignItems(.center).justifyContent(.center).height(194).define { flex in
                    flex.addItem(emptyLbl)
                    
                    flex.addItem(addNoValueBtn).margin(8, 0, 20, 0)
                }
            }
        } else {
            let needsSeeMore = !isSeeMoreSelected && allChecklistsItem.count > 5
            let filtered = needsSeeMore ? Array(allChecklistsItem.prefix(5)) : allChecklistsItem
            container.flex.define { flex in
                for item in filtered {
                    let row = ChecklistRow(item: item)
                    flex.addItem(row).margin(4, 24).height(52)
                }
                
                if needsSeeMore {
                    flex.addItem(seeMoreButton).margin(8, 24, 24).height(36)
                } else {
                    flex.addItem().height(20)
                }
            }
        }
        
        container.flex.isIncludedInLayout = true
        setNeedsLayout()
    }
    
}

extension ChecklistSection {
    
    func selectTab(tag: Int) {
        for button in tabButtons {
            let isSelected = button.tag == tag
            button.configuration?.baseBackgroundColor = isSelected ? .colorDark100 : .colorGrey10
            button.configuration?.baseForegroundColor = isSelected ? .white : .colorGrey50
        }
    }
    
    private func tabButton(tag: Int, title: String) -> UIButton {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        var attrText = AttributedString(title)
        attrText.font = .pretendard(.medium, 14)
        config.attributedTitle = attrText
        config.background.cornerRadius = 15
        config.baseBackgroundColor = .colorGrey10
        button.configuration = config
        button.tag = tag
        return button
    }
    
}
