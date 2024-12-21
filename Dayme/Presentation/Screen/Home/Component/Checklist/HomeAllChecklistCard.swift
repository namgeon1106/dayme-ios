//
//  HomeAllChecklistCard.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit
import FlexLayout
import PinLayout

final class HomeAllChecklistCard: CollectionViewCell {
    
    weak var delegate: HomeChecklistCardRowDelegate?
    
    // MARK: UI properties
    
    private let emojiLabel = UILabel("🔥").then {
        $0.font(.pretendard(.semiBold, 24))
    }
    
    private let titleLabel = UILabel("오늘의 체크리스트").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let checklistContainer = UIView()
    
    // MARK: Helpers
    
    override func setup() {
        contentView.backgroundColor = .colorBackground
        contentView.layer.cornerRadius = 12
        contentView.addShadow(.card)
    }
    
    override func setupFlex() {
        contentView.addSubview(flexView)
        
        flexView.flex.padding(20, 15).define { flex in
            let emojiContainer = CircleView()
            emojiContainer.layer.borderColor = .uiColor(.colorGrey20)
            emojiContainer.layer.borderWidth = 1.5
            flex.addItem().direction(.row).height(40).define { flex in
                flex.addItem(emojiContainer).justifyContent(.center).width(40).height(40).define { flex in
                    flex.addItem(emojiLabel).alignSelf(.center).position(.absolute)
                }
                
                flex.addItem().define { flex in
                    flex.addItem(titleLabel).marginHorizontal(10).grow(1)
                }
                
            }
            
            flex.addItem().marginTop(15).height(1).backgroundColor(.colorGrey20)
            
            flex.addItem(checklistContainer).marginTop(8).grow(1)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    
    // MARK: Bind
    
    /// 오늘의 체크리스트 (전체)
    func bind(all: [ChecklistDateItem]) {
        checklistContainer.flex.isIncludedInLayout = false
        
        checklistContainer.subviews.forEach { $0.removeFromSuperview() }
        checklistContainer.flex.define { flex in
            let rowItems: [RowItem] = all.flatMap { item in
                item.checklists.map { (goal: item.goal, checklist: $0) }
            }
            
            for rowItem in rowItems.prefix(4) {
                let row = HomeChecklistCardRow(item: rowItem)
                row.delegate = delegate
                flex.addItem(row).height(36)
            }
        }
        
        checklistContainer.flex.isIncludedInLayout = true
        
        setNeedsLayout()
    }
    
}
