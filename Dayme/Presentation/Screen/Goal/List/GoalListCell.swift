//
//  GoalListCell.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit
import FlexLayout
import PinLayout

final class GoalListCell: TableViewCell {
    
    private let progressBar = ProgressBar()
    private let emojiLbl = UILabel().then {
        $0.font(.pretendard(.semiBold, 22))
    }
    private let titleLbl = UILabel().then {
        $0.textColor(.colorDark100)
        $0.font(.pretendard(.semiBold, 16))
        $0.lineBreakMode = .byTruncatingTail
    }
    private let dateLbl = UILabel().then {
        $0.textColor(.colorBlue)
        $0.font(.pretendard(.regular, 12))
        $0.lineBreakMode = .byTruncatingTail
    }
    private let percentileLbl = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    
    func bind(_ goal: Goal) {
        emojiLbl.text = goal.emoji
        titleLbl.text = goal.title
        let startDate = goal.startDate.string(style: .dotted)
        let endDate = goal.endDate.string(style: .dotted)
        dateLbl.text = startDate + " ~ " + endDate
        progressBar.progress = goal.progress
        progressBar.tintColor = .hex(goal.hex)
        let percentile = String(format: "%.0f", goal.progress * 100)
        percentileLbl.text = "\(percentile)%"
        flexView.layer.borderColor = .uiColor(goal.displayHome ? .colorMain1 : .colorGrey20)
    }
    
    override func setup() {
        flexView.layer.cornerRadius = 16
        flexView.layer.borderWidth = 1
        flexView.layer.borderColor = .uiColor(.colorGrey20)
        flexView.clipsToBounds = true
        selectionStyle = .none
    }
    
    override func setupFlex() {
        contentView.addSubview(flexView)
        
        flexView.flex.padding(12, 0).define { flex in
            flex.addItem().direction(.row).height(44).define { flex in
                flex.addItem(CircleView()).justifyContent(.center).marginLeft(12).width(42).height(42).backgroundColor(.colorGrey10).define { flex in
                    flex.addItem(emojiLbl).alignSelf(.center).position(.absolute)
                }
                
                flex.addItem().margin(2, 8, 0, 0).define { flex in
                    flex.addItem(titleLbl)
                    
                    flex.addItem(dateLbl).marginTop(6)
                }
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(10).padding(0, 14).grow(1).define { flex in
                flex.addItem(progressBar).grow(1).height(8)
                
                flex.addItem(percentileLbl).marginLeft(8)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.vertically(5).horizontally(24)
        flexView.flex.layout()
    }
    
}
