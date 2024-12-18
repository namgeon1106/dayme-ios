//
//  ChecklistDateItemView.swift
//  Dayme
//
//  Created by 정동천 on 12/19/24.
//

import UIKit

protocol ChecklistDateItemViewDelegate: AnyObject {
    func checklistDateItemViewDidTap(_ view: ChecklistDateItemView)
}

final class ChecklistDateItemView: Vue {
    
    weak var delegate: ChecklistDateItemViewDelegate?
    
    var title: String {
        // Kor, 추후에 로컬라이징시 수정 필요
        ["일", "월", "화", "수", "목", "금", "토"][weekDay - 1]
    }
    
    /// 1(일요일) ~ 7(토요일)
    private(set) var weekDay: Int
    
    var isSelected: Bool = false {
        didSet {
            guard oldValue != isSelected else { return }
            update(weekDay)
        }
    }
    
    
    // MARK: UI properties
    
    private let weekDayLbl = UILabel().then {
        $0.font(.pretendard(.medium, 15))
    }
    
    
    // MARK: Lifecycles
    
    init(_ weekDay: Int) {
        self.weekDay = weekDay
        super.init(frame: .zero)
        
        update(weekDay)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
    }
    
    override func setupAction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapHandler)
        )
        addGestureRecognizer(tapGesture)
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.grow(1).alignItems(.center).justifyContent(.center).define { flex in
            flex.addItem(weekDayLbl)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    @objc private func tapHandler() {
        delegate?.checklistDateItemViewDidTap(self)
    }
    
    func update(_ weekDay: Int) {
        self.weekDay = weekDay
        
        weekDayLbl.text = title
        
        let isSunday = weekDay == 1
        
        backgroundColor = isSelected ? .colorMain1 : .colorBackground
        layer.borderWidth = isSelected ? 0 : 1
        layer.borderColor = .uiColor(.colorGrey20)
        
        weekDayLbl.textColor = isSelected ? .white
        : isSunday ? .colorRed : .colorDark70
        
        setNeedsLayout()
    }
    
}
