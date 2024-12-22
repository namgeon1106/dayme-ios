//
//  HomeDateGroupView.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit
import FlexLayout
import PinLayout

protocol HomeDateGroupViewDelegate: AnyObject {
    func homeDateGroupViewDidSelectItem(date: Date)
    func homeDateGroupViewDidTapPrev()
    func homeDateGroupViewDidTapNext()
}

final class HomeDateGroupView: Vue {
    
    weak var delegate: HomeDateGroupViewDelegate?
    
    private(set) var selectedDate: Date = Date()
    private(set) var weekDates: [Date] = []
    
    private let dateLbl = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.bold, 16))
    }
    
    private let prevBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey50
    }
    
    private let nextBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey50
    }
    
    private let prevBG = CircleView().then {
        $0.backgroundColor = .colorGrey20
    }
    
    private let nextBG = CircleView().then {
        $0.backgroundColor = .colorGrey20
    }
    
    private let dateContainer = UIView()
    
    
    override func setupAction() {
        prevBtn.onAction { [weak self] in
            self?.delegate?.homeDateGroupViewDidTapPrev()
        }
        
        nextBtn.onAction { [weak self] in
            self?.delegate?.homeDateGroupViewDidTapNext()
        }
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).padding(0, 1).height(44).define { flex in
                
                flex.addItem().width(44).justifyContent(.center).define { flex in
                    flex.addItem(prevBG)
                        .width(24)
                        .height(24)
                        .alignSelf(.center)
                    
                    flex.addItem(prevBtn)
                        .width(100%)
                        .height(100%)
                        .position(.absolute)
                }
                
                flex.addItem().alignItems(.center).justifyContent(.center).grow(1).define { flex in
                    flex.addItem(dateLbl).shrink(0)
                }
                
                flex.addItem().width(44).justifyContent(.center).define { flex in
                    flex.addItem(nextBG)
                        .width(24)
                        .height(24)
                        .alignSelf(.center)
                    
                    flex.addItem(nextBtn)
                        .width(100%)
                        .height(100%)
                        .position(.absolute)
                }
            }
            
            flex.addItem(dateContainer).height(49)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    func updateWeekDates(selectedDate: Date? = nil, weekDates: [Date]? = nil) {
        if let selectedDate {
            self.selectedDate = selectedDate
        }
        if let weekDates {
            self.weekDates = weekDates
            updateButton()
        }
        
        update()
    }
    
    private func update() {
        if let startDate = weekDates.first {
            dateLbl.text = startDate.string(format: "yyyy년 M월")
            dateLbl.flex.markDirty()
        }
        
        dateContainer.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        dateContainer.flex.direction(.row).padding(0, 12).height(49).define { flex in
            weekDates.forEach { date in
                let itemView = HomeDateItemView(date)
                itemView.isSelected = date.isSameDay(with: selectedDate)
                itemView.delegate = self
                flex.addItem(itemView).basis(0%).grow(1).marginHorizontal(4)
            }
        }
        
        setNeedsLayout()
    }
    
    private func updateButton() {
        let today = Date()
        let first = weekDates.first ?? selectedDate
        let last = weekDates.last ?? selectedDate
        let isPrevPressed = today > last && !today.isSameDay(with: last)
        let isNextPressed = today < first && !today.isSameDay(with: first)
        
        prevBG.isHidden = !isPrevPressed
        nextBG.isHidden = !isNextPressed
    }
    
}

// MARK: - HomeDateItemViewDelegate

extension HomeDateGroupView: HomeDateItemViewDelegate {
    
    func homeDateItemViewDidTap(_ view: HomeDateItemView) {
        delegate?.homeDateGroupViewDidSelectItem(date: view.date)
    }
    
}
