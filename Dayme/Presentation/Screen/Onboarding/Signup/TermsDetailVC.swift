//
//  TermsDetailVC.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import UIKit
import FlexLayout
import PinLayout
import Then

#Preview { TermsDetailVC(terms: .termsOfService) }

final class TermsDetailVC: VC {
    
    private let terms: Terms
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backBtn = UIButton().then {
        $0.image(.icBackward, for: .normal)
    }
    
    private lazy var titleLbl = UILabel(terms.title).then {
        $0.textColor(.colorDark100)
            .textAlignment(.left)
            .numberOfLines(0)
            .typo(.title24B)
    }
    
    private lazy var contentLbl = UILabel(terms.content).then {
        $0.textColor(.colorDark100)
            .textAlignment(.left)
            .numberOfLines(0)
            .typo(.body14R)
    }
    
    // MARK: Lifecycle
    
    init(terms: Terms) {
        self.terms = terms
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    
    override func setup() {
        view.backgroundColor(.colorBackground)
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .termsCanceled)
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { flex in
            flex.addItem().marginTop(19).alignItems(.start).define { flex in
                flex.addItem(backBtn).width(44).height(44).marginLeft(8)
            }
            
            flex.addItem().marginTop(11).paddingHorizontal(24).define { flex in
                flex.addItem(titleLbl)
                flex.addItem().height(24)
                flex.addItem(contentLbl)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
}
