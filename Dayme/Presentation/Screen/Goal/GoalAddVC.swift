//
//  GoalAddVC.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit
import FlexLayout
import PinLayout
import ElegantEmojiPicker

#Preview {
    UINavigationController(rootViewController: GoalAddVC())
}

final class GoalAddVM: ObservableObject {
    @Published var emoji: String = "🚀"
}

final class GoalAddVC: VC {
    
    private let vm = GoalAddVM()
    
    // MARK: UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey30
    }
    
    private let emojiCaptionLbl = UILabel("목표 이모지").then {
        $0.textColor(.colorGrey50)
            .font(.pretendard(.bold, 14))
    }
    
    private let emojiLbl = UILabel().then {
        $0.font(.pretendard(.semiBold, 40))
            .textAlignment(.center)
    }
    
    private let emojiBtn = UIButton()
    
    private let plusIV = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        $0.image = image
        $0.contentMode = .center
        $0.tintColor = .white
        $0.backgroundColor = .colorMain1
        $0.layer.cornerRadius = 10
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        title = "주요목표 추가"
        if let naviBar = navigationController?.navigationBar {
            var attributes = naviBar.titleTextAttributes.orEmpty
            attributes[.foregroundColor] = UIColor.colorDark100
            attributes[.font] = UIFont.pretendard(.semiBold, 16)
            naviBar.titleTextAttributes = attributes
        }
        navigationItem.leftBarButtonItem = .init(customView: backBtn)
        view.backgroundColor = .colorBackground
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .goalAddCanceled)
        }
        
        emojiBtn.onAction { [weak self] in
            self?.showEmojiPicker()
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.define { flex in
            flex.addItem(emojiCaptionLbl).margin(20, 24, 0, 0)
            
            flex.addItem().direction(.row).justifyContent(.center).define { flex in
                flex.addItem().width(78).height(78).justifyContent(.center).define { flex in
                    flex.addItem(CircleView())
                        .width(100%).height(100%)
                        .backgroundColor(.colorGrey10)
                        .position(.absolute)
                    
                    flex.addItem(plusIV)
                        .width(20).height(20)
                        .right(0).bottom(0)
                        .position(.absolute)
                    
                    flex.addItem(emojiLbl)
                        .width(100%).height(100%)
                        .position(.absolute)
                    
                    flex.addItem(emojiBtn)
                        .width(100%).height(100%)
                        .position(.absolute)
                }
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
    
    override func bind() {
        vm.$emoji.receive(on: RunLoop.main)
            .sink { [weak self] emoji in
                self?.emojiLbl.text = emoji
            }.store(in: &cancellables)
    }
    
    private func showEmojiPicker() {
        Haptic.impact(.medium)
        
        let picker = ElegantEmojiPicker(delegate: self)
        present(picker, animated: true)
    }
    
}

// MARK: - ElegantEmojiPickerDelegate

extension GoalAddVC: ElegantEmojiPickerDelegate {
    
    func emojiPicker(_ picker: ElegantEmojiPicker, didSelectEmoji emoji: Emoji?) {
        if let emoji = emoji?.emoji {
            vm.emoji = emoji
        }
    }
    
}
