//
//  HomeChecklistEmptyView.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit
import PinLayout

final class HomeChecklistEmptyView: Vue {
    
    private let emptyLabel = UILabel("체크리스트 없음").then {
        $0.textColor(.colorGrey30).font(.pretendard(.medium, 14))
    }
    
    override func setupFlex() {
        emptyLabel.sizeToFit()
        addSubview(emptyLabel)
    }
    
    override func layoutFlex() {
        emptyLabel.center = center
    }
    
}
