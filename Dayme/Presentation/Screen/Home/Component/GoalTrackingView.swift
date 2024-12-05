//
//  GoalTrackingView.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

final class GoalTrackingView: Vue {
    
    let item: GoalTrackingItem
    
    private lazy var emojiLbl = UILabel(item.emoji).then {
        $0.font(.pretendard(.medium, 24))
    }
    
    private lazy var titleLbl = UILabel(item.title).then {
        $0.textColor(.colorDark100).font(Typo.body14M.font)
    }
    
    private lazy var progressLbl = UILabel().then {
        $0.text(String(format: "%.0f", item.progress * 100))
            .textColor(.colorGrey50)
            .font(.pretendard(.semiBold, 12))
    }
    
    private lazy var progressBar = ProgressBar().then {
        $0.progress = item.progress
        $0.tintColor = .hex(item.hex)
    }
    
    init(_ item: GoalTrackingItem) {
        self.item = item
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.direction(.row).alignItems(.center).height(24).define { flex in
            flex.addItem(emojiLbl).margin(1, 0, 0, 8)
            
            flex.addItem().grow(1).define { flex in
                flex.addItem().direction(.row).grow(1).define { flex in
                    flex.addItem(titleLbl)
                    
                    flex.addItem().grow(1)
                    
                    flex.addItem(progressLbl)
                }
                
                flex.addItem(progressBar).marginTop(4).height(6)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
    }
    
}
