//
//  SubgoalCard.swift
//  Dayme
//
//  Created by 정동천 on 12/13/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview(traits: .fixedLayout(width: 152, height: 164)) {
    SubgoalCard(mockSubgoals[0])
}
#endif

protocol SubgoalCardDelegate: AnyObject {
    func subgoalCardEditButtonTapped(_ subgoal: Subgoal)
}

final class SubgoalCard: Vue {
    
    weak var delegate: SubgoalCardDelegate?
    
    let subgoal: Subgoal
    
    // MARK: - UI properties
    
    private let categoryLbl = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.regular, 12))
    }
    
    private let titleLbl = UILabel().then {
        $0.textColor(.colorDark100)
        $0.font(.pretendard(.semiBold, 14))
        $0.numberOfLines(2)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let startDateLbl = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.medium, 10))
    }
    
    private let endDateLbl = UILabel().then {
        $0.textColor(.colorGrey50).font(.pretendard(.medium, 10))
    }
    
    private let progressCaptionLbl = UILabel("달성/전체").then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 10))
    }
    
    private let progressLbl = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 10))
    }
    
    private let progressBar = ProgressBar()
    
    private let editBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = .icEllipsis
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 3, trailing: 0)
        $0.configuration = config
    }
    
    
    // MARK: - Lifecycles
    
    init(_ subgoal: Subgoal) {
        self.subgoal = subgoal
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    override func setup() {
        backgroundColor = .colorBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = .uiColor(.colorGrey20)
        
        categoryLbl.text = subgoal.category
        titleLbl.text = subgoal.title
        titleLbl.lineHeight(multiple: 1.2)
        startDateLbl.text = subgoal.startDate.string(style: .dotted)
        endDateLbl.text = subgoal.endDate.string(style: .dotted)
        progressBar.progress = subgoal.progress
        progressBar.tintColor = .colorMain1
        progressLbl.text = String(format: "%.0f%%", subgoal.progress * 100)
    }
    
    override func setupFlex() {
        addSubview(flexView)
        addSubview(editBtn)
        
        let categoryContainer = UIView()
        categoryContainer.layer.cornerRadius = 4
        categoryContainer.backgroundColor = .colorGrey10
        
        flexView.flex.padding(10).define { flex in
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(categoryContainer).justifyContent(.center).height(22).define { flex in
                    flex.addItem(categoryLbl).marginHorizontal(6)
                }
                
                flex.addItem().grow(1)
            }
            
            flex.addItem(titleLbl).marginTop(12)
            
            flex.addItem().grow(1)
            
            flex.addItem().direction(.row).marginTop(4).define { flex in
                flex.addItem(progressCaptionLbl)
                
                flex.addItem().grow(1)
                
                flex.addItem(progressLbl)
            }
            
            flex.addItem(progressBar).marginVertical(4).height(6)
            
            flex.addItem().direction(.row).define { flex in
                flex.addItem(startDateLbl)
                
                flex.addItem().grow(1)
                
                flex.addItem(endDateLbl)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
        editBtn.pin.top().right().width(44).height(44)
    }
    
    // MARK: - Events
    
    override func setupAction() {
        editBtn.onAction { [weak self] in
            guard let self else { return }
            delegate?.subgoalCardEditButtonTapped(subgoal)
        }
    }
    
}
