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
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.frame.size.height = 1000
        scrollView.contentSize = contentView.bounds.size
    }
    
}
