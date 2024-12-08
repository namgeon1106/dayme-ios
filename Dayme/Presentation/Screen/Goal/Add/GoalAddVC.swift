//
//  GoalAddVC.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout
import ElegantEmojiPicker

#if DEBUG
#Preview {
    UINavigationController(rootViewController: GoalAddVC())
}
#endif

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
    private let doneBtn = FilledButton("추가하기").then {
        $0.isEnabled = false
    }
    private let doneBtnContainer = UIView().then {
        $0.backgroundColor = .colorBackground
    }
    
    // 이모지
    private let emojiCaptionLbl = UILabel("목표 이모지").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private let emojiLbl = UILabel().then {
        $0.font(.pretendard(.semiBold, 40))
            .textAlignment(.center)
    }
    private let emojiBtn = UIButton()
    private let emojiPlusIV = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .heavy)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        $0.image = image
        $0.contentMode = .center
        $0.tintColor = .white
        $0.backgroundColor = .colorMain1
        $0.layer.cornerRadius = 10
    }
    
    // 제목
    private let titleCaptionLbl = UILabel("제목").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private let titleTF = BorderedTF("제목을 입력해주세요").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.returnKeyType = .next
        $0.clearButtonMode = .whileEditing
    }
    
    // 기간
    private let durationCaptionLbl = UILabel("기간").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private lazy var durationStartTF = BorderedTF("시작일").then {
        $0.textAlignment = .center
        $0.inputView = datePicker
        $0.inputAccessoryView = dateToolbar
    }
    private lazy var durationEndTF = BorderedTF("목표일").then {
        $0.textAlignment = .center
        $0.inputView = datePicker
        $0.inputAccessoryView = dateToolbar
    }
    private let durationTildeLbl = UILabel("~").then {
        $0.textColor(.colorGrey30).font(.pretendard(.medium, 16))
    }
    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .inline
        $0.tintColor = .colorMain1
        $0.backgroundColor = .white
    }
    private lazy var dateToolbar = UIToolbar().then {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDoneButtonDidTap))
        $0.items = [flexibleSpace, doneButton]
        $0.sizeToFit()
        $0.tintColor = .colorMain1
        $0.backgroundColor = .colorBackground
        $0.isTranslucent = false
    }
    
    // 색상
    private let colorCaptionLbl = UILabel("목표 색상").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private let palleteView = PalleteView()
    
    // 홈에 표시
    private let homeCaptionLbl = UILabel("홈에 표시").then {
        $0.textColor(.colorDark100).font(.pretendard(.medium, 16))
    }
    private let homeSwitch = UISwitch().then {
        $0.onTintColor = .colorMain1
    }
    
    
    // MARK: Helpers
    
    override func setup() {
        addKeyboardObeserver()
        
        title = "주요목표 추가"
        if let naviBar = navigationController?.navigationBar {
            var attributes = naviBar.titleTextAttributes.orEmpty
            attributes[.foregroundColor] = UIColor.colorDark100
            attributes[.font] = UIFont.pretendard(.semiBold, 16)
            naviBar.titleTextAttributes = attributes
        }
        navigationItem.leftBarButtonItem = .init(customView: backBtn)
        view.backgroundColor = .colorBackground
        scrollView.keyboardDismissMode = .interactive
        titleTF.delegate = self
        palleteView.delegate = self
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .goalAddCanceled)
        }
        
        emojiBtn.onAction { [weak self] in
            self?.showEmojiPicker()
        }
        
        titleTF.onAction { [weak self] in
            guard let self else { return }
            vm.title = titleTF.text.orEmpty
        }
        
        durationStartTF.onAction(for: .editingDidBegin) { [weak self] in
            guard let self else { return }
            
            Haptic.impact(.light)
            
            datePicker.minimumDate = nil
            if let startDate = vm.startDate {
                datePicker.date = startDate
                vm.startDate = nil
            }
            if let endDate = vm.endDate {
                datePicker.maximumDate = endDate
            }
        }
        
        durationEndTF.onAction(for: .editingDidBegin) { [weak self] in
            guard let self else { return }
            
            datePicker.maximumDate = nil
            if let startDate = vm.startDate {
                datePicker.minimumDate = startDate
            }
            if let endDate = vm.endDate {
                datePicker.date = endDate
                vm.endDate = nil
            }
        }
        
        datePicker.onAction(for: .valueChanged) { [weak self] in
            self?.pickerValueChanged()
        }
        
        homeSwitch.onAction(for: .valueChanged) { [weak self] in
            guard let self else { return }
            vm.displayeHome = homeSwitch.isOn
        }
        
        doneBtn.onAction { [weak self] in
            await self?.addGoal()
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(doneBtnContainer)
        doneBtnContainer.addSubview(doneBtn)
        
        contentView.flex.define { flex in
            flex.addItem(emojiCaptionLbl).margin(20, 24, 0, 0)
            
            flex.addItem().direction(.row).justifyContent(.center).define { flex in
                flex.addItem().width(78).height(78).justifyContent(.center).define { flex in
                    flex.addItem(CircleView())
                        .width(100%).height(100%)
                        .backgroundColor(.colorGrey10)
                        .position(.absolute)
                    
                    flex.addItem(emojiPlusIV)
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
            
            flex.addItem(titleCaptionLbl).margin(8, 24, 0, 0)
            
            flex.addItem(titleTF).margin(4, 24, 0, 24).height(51)
            
            flex.addItem().margin(24, 0).height(4)
                .backgroundColor(.colorGrey10)
            
            flex.addItem(durationCaptionLbl).margin(0, 24, 0, 0)
            
            flex.addItem().direction(.row).margin(4, 24, 0).height(51).define { flex in
                flex.addItem(durationStartTF).basis(0%).grow(1)
                
                flex.addItem(durationTildeLbl).margin(0, 4)
                
                flex.addItem(durationEndTF).basis(0%).grow(1)
            }
            
            flex.addItem().margin(24, 0).height(4)
                .backgroundColor(.colorGrey10)
            
            flex.addItem().direction(.row).alignItems(.start).padding(6, 24).define { flex in
                flex.addItem(colorCaptionLbl).marginTop(10)
                
                flex.addItem(palleteView).marginLeft(25)
                
                flex.addItem().grow(1)
            }
            
            let homeContainer = UIView()
            homeContainer.layer.cornerRadius = 8
            homeContainer.layer.borderWidth = 1
            homeContainer.layer.borderColor = .uiColor(.colorGrey20)
            
            flex.addItem(homeContainer).direction(.row).alignItems(.center).margin(20, 24).height(58).padding(0, 12).define { flex in
                flex.addItem(homeCaptionLbl)
                
                flex.addItem().grow(1)
                
                flex.addItem(homeSwitch)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = contentView.bounds.size
        
        let bottomInset = view.safeAreaInsets.bottom
        let buttonHeight: CGFloat = 56
        let containerHeight = buttonHeight + bottomInset + 8 * 2
        doneBtnContainer.pin.horizontally().bottom().height(containerHeight)
        doneBtn.pin.bottom(bottomInset + 8).horizontally(24).height(buttonHeight)
    }
    
    override func bind() {
        vm.$emoji.receive(on: RunLoop.main)
            .sink { [weak self] emoji in
                self?.emojiLbl.text = emoji
            }.store(in: &cancellables)
        
        vm.$startDate.receive(on: RunLoop.main)
            .sink { [weak self] date in
                let text = date?.string(style: .goalDuration)
                self?.durationStartTF.text = text
            }.store(in: &cancellables)
        
        vm.$endDate.receive(on: RunLoop.main)
            .sink { [weak self] date in
                let text = date?.string(style: .goalDuration)
                self?.durationEndTF.text = text
            }.store(in: &cancellables)
        
        vm.$color.receive(on: RunLoop.main)
            .sink { [weak self] color in
                self?.palleteView.selectedColor = color
            }.store(in: &cancellables)
        
        vm.$isValidate
            .receive(on: RunLoop.main)
            .sink { [weak self] validate in
                self?.doneBtn.isEnabled = validate
            }.store(in: &cancellables)
    }
    
    override func keyboardWillShow(_ height: CGFloat) {
        scrollView.contentInset.bottom = height
    }
    
    override func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
    }
    
    private func showEmojiPicker() {
        Haptic.impact(.medium)
        
        view.endEditing(true)
        
        let config = ElegantConfiguration(showRandom: false, showReset: false, showClose: false)
        let picker = ElegantEmojiPicker(delegate: self, configuration: config)
        present(picker, animated: true)
    }
    
    private func pickerValueChanged() {
        if durationStartTF.isFirstResponder {
            vm.startDate = datePicker.date
        } else if durationEndTF.isFirstResponder {
            vm.endDate = datePicker.date
        }
    }
    
    @objc private func dateDoneButtonDidTap() {
        Haptic.impact(.light)
        
        if durationStartTF.isFirstResponder {
            if vm.endDate == nil {
                _ = durationEndTF.becomeFirstResponder()
            } else {
                _ = durationStartTF.resignFirstResponder()
            }
        } else if durationEndTF.isFirstResponder {
            _ = durationEndTF.resignFirstResponder()
        }
    }
    
    @MainActor
    private func addGoal() async {
        do {
            Loader.show(in: view)
            try await vm.addGoal()
            Loader.dismiss()
            Haptic.noti(.success)
            coordinator?.trigger(with: .goalAddCanceled)
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 목표 추가 실패", message: error.localizedDescription)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension GoalAddVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTF {
            if vm.startDate == nil {
                _ = durationStartTF.becomeFirstResponder()
            } else {
                _ = titleTF.resignFirstResponder()
            }
        }
        
        return true
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

// MARK: - PalleteViewDelegate

extension GoalAddVC: PalleteViewDelegate {
    
    func palleteViewDidSelect(_ color: PalleteColor) {
        vm.color = color
    }
    
}
