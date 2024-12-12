//
//  GoalDetailVC.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vm = GoalDetailVM(goal: mockGoals[0])
    let vc = GoalDetailVC(vm: vm)
    return UINavigationController(rootViewController: vc)
}
#endif

final class GoalDetailVC: VC {
    
    private let vm: GoalDetailVM
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backBtn = naviBackButton()
    
    // 주요 목표
    private let goalProgressBar = ProgressBar().then {
        $0.backgroundColor = .colorGrey10
    }
    private let goalEmojiLbl = UILabel().then {
        $0.font(.pretendard(.semiBold, 32))
    }
    private let goalTitleLbl = UILabel().then {
        $0.textColor(.colorDark100)
        $0.font(.pretendard(.medium, 18))
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    private let goalDateLbl = UILabel().then {
        $0.textColor(.colorGrey50)
        $0.font(.pretendard(.medium, 14))
        $0.lineBreakMode = .byTruncatingTail
    }
    
    // 세부 목표
    private let subgoalSubtitleLbl = UILabel("세부목표").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    
    // 체크리스트
    private let checklistSubtitleLbl = UILabel("체크리스트").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    
    // 홈 화면 표시
    private let homeSubtitleLbl = UILabel("홈 화면 표시").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let homeCaptionLbl = UILabel("홈에 표시").then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 16))
    }
    private let homeSwitch = UISwitch().then {
        $0.onTintColor = .colorMain1
    }
    private let homeContainer = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .uiColor(.colorGrey20)
    }
    private let homeWarningLbl = UILabel("홈 화면에는 목표가 최대 3개까지만 표시됩니다.").then {
        $0.textColor(.colorRed)
        $0.font(.pretendard(.medium, 14))
        $0.alpha = 0
    }
    
    
    // MARK: Lifecycles
    
    init(vm: GoalDetailVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        setNaviTitle("주요목표 정보")
        navigationItem.leftBarButtonItem = .init(customView: backBtn)
        view.backgroundColor = .colorBackground
        scrollView.keyboardDismissMode = .interactive
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .goalDetailCanceled)
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let emojiContainer = CircleView()
        emojiContainer.layer.borderColor = .uiColor(.colorGrey20)
        emojiContainer.layer.borderWidth = 2
        
        contentView.flex.define { flex in
            flex.addItem().padding(0, 28).marginTop(32).define { flex in
                flex.addItem().direction(.row).alignItems(.center).height(60).define { flex in
                    flex.addItem(emojiContainer).justifyContent(.center).width(60).height(60).define { flex in
                        flex.addItem(goalEmojiLbl).alignSelf(.center).position(.absolute)
                    }
                    
                    flex.addItem().marginLeft(12).shrink(1).define { flex in
                        flex.addItem(goalTitleLbl)
                        
                        flex.addItem(goalDateLbl).marginTop(6)
                    }
                }
                
                flex.addItem(goalProgressBar).margin(18, 0, 24, 0).height(24)
            }
            
            flex.addItem().height(1).backgroundColor(.colorGrey20)
            
            flex.addItem().height(242).define { flex in
                flex.addItem(subgoalSubtitleLbl).margin(24, 24, 0, 0)
            }
            
            flex.addItem().height(8).backgroundColor(.colorGrey20)
            
            flex.addItem().height(283).define { flex in
                flex.addItem(checklistSubtitleLbl).margin(24, 24, 0, 0)
            }
            
            flex.addItem().height(8).backgroundColor(.colorGrey20)
            
            flex.addItem(homeSubtitleLbl).margin(24, 24, 0, 0)
            
            flex.addItem(homeContainer).direction(.row).alignItems(.center).margin(12, 24, 0, 24).height(58).padding(0, 12).define { flex in
                flex.addItem(homeCaptionLbl)
                
                flex.addItem().grow(1)
                
                flex.addItem(homeSwitch)
            }
            
            flex.addItem(homeWarningLbl).margin(15, 24, 20, 0)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.pin.width(of: scrollView)
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func bind() {
        let goal = vm.goal
        let startDate = goal.startDate.string(style: .dotted)
        let endDate = goal.endDate.string(style: .dotted)
        goalEmojiLbl.text = goal.emoji
        goalTitleLbl.text = goal.title
        goalDateLbl.text = "\(startDate) ~ \(endDate)"
        goalProgressBar.progress = goal.progress
        goalProgressBar.tintColor = .hex(goal.hex)
        
        view.setNeedsLayout()
    }
    
}
