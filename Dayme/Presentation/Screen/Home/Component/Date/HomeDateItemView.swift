//
//  HomeDateItemView.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit

protocol HomeDateItemViewDelegate: AnyObject {
    func homeDateItemViewDidTap(_ view: HomeDateItemView)
}

final class HomeDateItemView: Vue {
    
    weak var delegate: HomeDateItemViewDelegate?
    
    var date: Date
    
    var isSelected: Bool = false {
        didSet {
            guard oldValue != isSelected else { return }
            update(date)
        }
    }
    
    
    // MARK: UI properties
    
    private let weekDayLbl = UILabel().then {
        $0.font(.pretendard(.medium, 11))
    }
    
    private let dayLbl = UILabel().then {
        $0.font(.pretendard(.medium, 14))
    }
    
    
    // MARK: Lifecycles
    
    init(_ date: Date) {
        self.date = date
        super.init(frame: .zero)
        
        update(date)
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
            
            flex.addItem().height(2)
            
            flex.addItem(dayLbl)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    @objc private func tapHandler() {
        delegate?.homeDateItemViewDidTap(self)
    }
    
    func update(_ date: Date) {
        self.date = date
        
        weekDayLbl.text = date.string(style: .weekday)
        dayLbl.text = date.string(style: .day)
        
        let isToday = date.isToday()
        let isSunday = date.isSunday()
        
        backgroundColor = isSelected ? .colorMain1 : .colorBackground
        layer.borderWidth = isSelected ? 0 : isToday ? 1.5 : 1
        layer.borderColor = .uiColor(isToday ? .colorMain1 : .colorGrey20)
        
        weekDayLbl.textColor = isSelected ? .white
        : isToday ? .colorMain1
        : isSunday ? .colorRed : .colorDark70
        
        dayLbl.textColor = isSelected ? .white
        : isToday ? .colorMain1
        : isSunday ? .colorRed : .colorDark100
        
        setNeedsLayout()
    }
    
}
