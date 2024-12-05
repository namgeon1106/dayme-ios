//
//  HomeVC.swift
//  Dayme
//
//  Created by 정동천 on 12/4/24.
//

import UIKit

#Preview {
    UINavigationController(rootViewController: HomeVC())
}

final class HomeVC: VC {
    
    // MARK: UI Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let dashboard = HomeDashboard()
    
    private let logo = UILabel("DAYME").then {
        $0.textColor(.colorMain1)
            .font(.montserrat(.black, 20))
    }
    
    private let userSV = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let nicknameLbl = UILabel("우채윤님").then {
        $0.textColor(.colorGrey50)
            .font(.pretendard(.medium, 16))
    }
    
    private let profileIV = UIImageView(image: .icProfileDefault)
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor = .colorSnow
        userSV.addArrangedSubview(nicknameLbl)
        userSV.addArrangedSubview(profileIV)
        navigationItem.leftBarButtonItem = .init(customView: logo)
        navigationItem.rightBarButtonItem = .init(customView: userSV)
        scrollView.showsVerticalScrollIndicator = false
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.height(1000).define { flex in
            flex.addItem(dashboard).margin(15).height(276)
            
            flex.addItem().grow(1)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func bind() {
        dashboard.updateItems(mockGoalTrackingItems)
    }
    
}
