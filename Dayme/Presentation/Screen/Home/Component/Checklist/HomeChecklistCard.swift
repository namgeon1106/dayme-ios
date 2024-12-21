//
//  HomeChecklistCard.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit
import FlexLayout
import PinLayout

final class HomeChecklistCard: CollectionViewCell {
    
    weak var delegate: HomeChecklistCardRowDelegate?
    
    // MARK: UI properties
    
    private let emojiLabel = UILabel().then {
        $0.font(.pretendard(.semiBold, 24))
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let goalCaptionLabel = UILabel("주요목표명").then {
        $0.textColor(.colorGrey50).font(.pretendard(.medium, 14))
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let checklistContainer = UIView()
    
    private let progressCaptionLbl = UILabel("진행률").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 12))
    }
    
    private let progressLbl = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 12))
    }
    
    private let progressBar = ProgressBar()
    
    
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
                    flex.addItem(goalCaptionLabel).marginHorizontal(10).grow(1)
                }
                
            }
            
            flex.addItem().marginTop(15).height(1).backgroundColor(.colorGrey20)
            
            flex.addItem(checklistContainer).marginTop(8).grow(1)
            
            flex.addItem().define { flex in
                flex.addItem().direction(.row).define { flex in
                    flex.addItem(progressCaptionLbl)
                    
                    flex.addItem().grow(1)
                    
                    flex.addItem(progressLbl)
                }
                
                flex.addItem(progressBar).marginTop(4).height(6)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    
    // MARK: Bind
    
    /// 주요목표별 체크리스트
    func bind(item: ChecklistDateItem) {
        emojiLabel.text = item.goal.emoji
        emojiLabel.flex.markDirty()
        titleLabel.text = item.goal.title
        titleLabel.flex.markDirty()
        progressLbl.text(String(format: "%.0f", item.goal.progress * 100))
        progressLbl.flex.markDirty()
        progressBar.progress = item.goal.progress
        progressBar.tintColor = .hex(item.goal.hex)
        
        checklistContainer.subviews.forEach { $0.removeFromSuperview() }
        checklistContainer.flex.define { flex in
            
            let rowItems: [RowItem] = item.checklists.map { checklist in
                (goal: item.goal, checklist: checklist)
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
