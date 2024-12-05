//
//  HomeDateView.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit
import FlexLayout
import PinLayout

final class HomeDateView: Vue {
    
    private let dateLbl = UILabel("2024년 12월").then {
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
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.define { flex in
            flex.addItem().direction(.row).padding(0, 1).height(44).define { flex in
                flex.addItem(prevBtn).width(44)
                
                flex.addItem().alignItems(.center).justifyContent(.center).grow(1).define { flex in
                    flex.addItem(dateLbl)
                }
                
                flex.addItem(nextBtn).width(44)
            }
            
            flex.addItem().direction(.row).padding(0, 12).height(49).define { flex in
                let weekDays = ["월", "화", "수", "목", "금", "토", "일"]
                weekDays.enumerated().forEach { offset, weekDay in
                    let view = UIView()
                    view.backgroundColor = .white
                    view.layer.cornerRadius = 12
                    view.layer.borderWidth = 1
                    view.layer.borderColor = .uiColor(.colorGrey20)
                    
                    let isSunday = weekDay == "일"
                    let redColor = UIColor.hex("#ED1E1D")
                    
                    let weekDayLbl = UILabel(weekDay)
                        .textColor(isSunday ? redColor : .colorDark70)
                        .font(.pretendard(.medium, 11))
                    let dayLbl = UILabel("\(offset + 1)")
                        .textColor(isSunday ? redColor : .colorDark100)
                        .font(.pretendard(.medium, 14))
                    
                    flex.addItem(view).grow(1).alignItems(.center).justifyContent(.center).marginHorizontal(4).define { flex in
                        flex.addItem(weekDayLbl)
                        
                        flex.addItem().height(2)
                        
                        flex.addItem(dayLbl)
                    }
                }
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
    }
    
}
