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
    func checklistSectionDidTapCheckButton(_ checklist: Checklist)
    func checklistSectionDidUpdateLayout()
}

final class ChecklistSection: Vue {
    
    weak var delegate: ChecklistSectionDelegate?
    
    private var goal: Goal
    /// 전체 체크리스트 더보기 선택 여부
    private var isSeeMoreSelected: Bool = false
    private var selectedTab: Int = 0
    private var selectedSubgoalIndex: Int = 0
    
    private var goalChecklistItems: [ChecklistItem] = []
    private var subgoalChecklistItems: [[ChecklistItem]] = []
    
    // MARK: - UI properties
    
    private let container = UIView()
    
    private let subgoalCaptionLbl = UILabel("체크리스트").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let subgoalTitleLbl = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.bold, 14))
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
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
    
    private let prevBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey50
    }
    private let nextBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey50
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
        selectTab(tag: 0)
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(subgoalCaptionLbl).margin(24, 24, 8, 0)
                
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
        flexView.flex.layout(mode: .adjustHeight)
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
            self?.delegate?.checklistSectionDidUpdateLayout()
        }
        
        prevBtn.onAction { [weak self] in
            guard let self, selectedSubgoalIndex > 0 else { return }
            self.selectedSubgoalIndex -= 1
            updateBySubgoal(index: selectedSubgoalIndex)
        }
        
        nextBtn.onAction { [weak self] in
            guard let self, selectedSubgoalIndex < subgoalChecklistItems.count - 1 else { return }
            self.selectedSubgoalIndex += 1
            updateBySubgoal(index: selectedSubgoalIndex)
        }
    }
    
    
    func update(goal: Goal? = nil) {
        if let goal {
            self.goalChecklistItems = goal.checklists.map { (goal.title, $0) }
            self.subgoalChecklistItems = goal.subgoals
                .filter { subgoal in !subgoal.checklists.isEmpty }
                .map { subgoal -> [ChecklistItem] in
                    subgoal.checklists.map { (subgoal.title, $0) }
                }
            
            self.goal = goal
        }
        
        tabSubgoalsButton.isHidden = subgoalChecklistItems.isEmpty
        
        if selectedTab == 0 {
            updateAll()
        } else if selectedTab == 1, subgoalChecklistItems.indices ~= selectedSubgoalIndex {
            updateBySubgoal(index: selectedSubgoalIndex)
        }
    }
    
    private func updateAll() {
        container.flex.isIncludedInLayout = false
        
        container.subviews.forEach { $0.removeFromSuperview() }
        
        let allChecklistItems = goalChecklistItems + subgoalChecklistItems.flatMap { $0 }
        
        if allChecklistItems.isEmpty {
            container.flex.define { flex in
                flex.addItem().alignItems(.center).justifyContent(.center).height(194).define { flex in
                    flex.addItem(emptyLbl)
                    
                    flex.addItem(addNoValueBtn).margin(8, 0, 20, 0)
                }
            }
        } else {
            let needsSeeMore = !isSeeMoreSelected && allChecklistItems.count > 5
            let filtered = needsSeeMore ? Array(allChecklistItems.prefix(5)) : allChecklistItems
            container.flex.define { flex in
                for item in filtered {
                    let row = ChecklistRow(item: item)
                    row.delegate = self
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
        delegate?.checklistSectionDidUpdateLayout()
    }
    
    private func updateBySubgoal(index: Int) {
        container.flex.isIncludedInLayout = false
        
        container.subviews.forEach { $0.removeFromSuperview() }
        
        let checklistItems = subgoalChecklistItems[index]
        
        let needsSeeMore = !isSeeMoreSelected && checklistItems.count > 5
        let filtered = needsSeeMore ? Array(checklistItems.prefix(5)) : checklistItems
        
        subgoalTitleLbl.text = checklistItems.first?.goalTitle
        prevBtn.isHidden = index <= 0
        nextBtn.isHidden = index >= (subgoalChecklistItems.count - 1)
        
        container.flex.define { flex in
            flex.addItem().direction(.row).marginHorizontal(12).define { flex in
                flex.addItem(prevBtn).width(44).height(44)
                
                flex.addItem().grow(1)
                
                flex.addItem(subgoalTitleLbl).shrink(1)
                
                flex.addItem().grow(1)
                
                flex.addItem(nextBtn).width(44).height(44)
            }
            
            
            for item in filtered {
                let row = ChecklistRow(item: item)
                row.delegate = self
                flex.addItem(row).margin(4, 24).height(52)
            }
            
            if needsSeeMore {
                flex.addItem(seeMoreButton).margin(8, 24, 24).height(36)
            } else {
                flex.addItem().height(20)
            }
        }
        
        container.flex.isIncludedInLayout = true
        setNeedsLayout()
        delegate?.checklistSectionDidUpdateLayout()
    }
    
}

extension ChecklistSection {
    
    func selectTab(tag: Int) {
        for button in tabButtons {
            let isSelected = button.tag == tag
            button.configuration?.baseBackgroundColor = isSelected ? .colorDark100 : .colorGrey10
            button.configuration?.baseForegroundColor = isSelected ? .white : .colorGrey50
            button.isUserInteractionEnabled = !isSelected
        }
        
        if selectedTab != tag {
            // 더보기 상태 초기화
            isSeeMoreSelected = false
        }
        
        selectedTab = tag
        
        update()
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
        button.onAction { [weak self] in
            Haptic.impact(.light)
            self?.selectTab(tag: tag)
        }
        return button
    }
    
}

// MARK: - ChecklistRowDelegate

extension ChecklistSection: ChecklistRowDelegate {
    
    func checklistRowDidTap(_ checklist: Checklist) {
        delegate?.checklistSectionDidTapEditButton(checklist)
    }
    
    func checklistRowDidTapCheck(_ checklist: Checklist) {
        delegate?.checklistSectionDidTapCheckButton(checklist)
    }
    
}
