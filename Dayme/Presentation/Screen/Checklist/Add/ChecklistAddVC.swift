//
//  ChecklistAddVC.swift
//  Dayme
//
//  Created by 정동천 on 12/16/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vm = ChecklistAddVM(goal: mockGoals[0], subgoal: nil)
    return ChecklistAddVC(vm: vm)
}
#endif

final class ChecklistAddVC: VC {
    
    let modalHeight: CGFloat = 520
    
    let vm: ChecklistAddVM
    
    // MARK: - UI properties
    
    private let headerLbl = UILabel("체크리스트 추가").then {
        $0.textColor(.colorDark100)
            .font(.pretendard(.bold, 20))
    }
    private let doneBtn = FilledButton("저장하기").then {
        $0.isEnabled = false
    }
    
    // 제목
    private let titleCaptionLbl = UILabel("제목").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private let titleTF = BorderedTF("체크리스트 제목을 작성해주세요").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.returnKeyType = .next
        $0.clearButtonMode = .whileEditing
    }
    
    // 주요 목표
    private let goalCaptionLbl = UILabel("주요목표").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private lazy var goalTF = BorderedTF("주요목표 선택").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.inputView = goalPicker
        $0.inputAccessoryView = toolbar
    }
    private lazy var goalPicker = UIPickerView().then {
        $0.tintColor = .colorMain1
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }
    
    // 세부 목표
    private let subgoalCaptionLbl = UILabel("세부목표").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private lazy var subgoalTF = BorderedTF("세부목표 선택").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.inputView = subgoalPicker
        $0.inputAccessoryView = toolbar
    }
    private lazy var subgoalPicker = UIPickerView().then {
        $0.tintColor = .colorMain1
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var toolbar = UIToolbar().then {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolbarDoneButtonDidTap))
        $0.items = [flexibleSpace, doneButton]
        $0.sizeToFit()
        $0.tintColor = .colorMain1
        $0.backgroundColor = .colorBackground
        $0.isTranslucent = false
    }
    
    
    // MARK: - Lifecycles
    
    init(vm: ChecklistAddVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Event
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    
    // MARK: - Helpers
    
    override func setup() {
        addKeyboardObeserver()
        
        view.backgroundColor = .clear
        flexView.backgroundColor = .colorBackground
        flexView.layer.cornerRadius = 24
        flexView.addShadow(.modal)
        titleTF.delegate = self
    }
    
    override func setupAction() {
        titleTF.onAction { [weak self] in
            guard let self else { return }
            vm.title = titleTF.text.orEmpty
        }
        
        subgoalTF.onAction(for: .editingDidBegin) { [weak self] in
            self?.vm.subgoal = nil
        }
        
        doneBtn.onAction { [weak self] in
            await self?.addChecklist()
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        
        let grabber = CircleView()
        grabber.backgroundColor = .colorGrey20
        flexView.flex.padding(16).define { flex in
            flex.addItem().direction(.row).justifyContent(.center).define { flex in
                flex.addItem(grabber).width(54).height(5)
            }
            
            flex.addItem(headerLbl).marginVertical(20)
            
            flex.addItem(titleCaptionLbl)
            
            flex.addItem(titleTF).marginTop(4).height(51)
            
            flex.addItem(goalCaptionLbl).marginTop(20)
            
            flex.addItem(goalTF).marginTop(4).height(51)
            
            flex.addItem(subgoalCaptionLbl).marginTop(20)
            
            flex.addItem(subgoalTF).marginTop(4).height(51)
            
            flex.addItem().grow(1)
            
            flex.addItem(doneBtn).height(56)
        }
    }
    
    override func layoutFlex() {
        let bottomInset: CGFloat = 30
        let height = modalHeight - bottomInset
        flexView.pin.top().horizontally(8).height(height)
        flexView.flex.layout()
    }
    
    override func bind() {
        vm.$goal.receive(on: RunLoop.main)
            .sink { [weak self] goal in
                self?.goalTF.text = goal.title
            }.store(in: &cancellables)
        
        vm.$subgoal.receive(on: RunLoop.main)
            .sink { [weak self] subgoal in
                self?.subgoalTF.text = subgoal?.title
            }.store(in: &cancellables)
        
        vm.$isValidate.receive(on: RunLoop.main)
            .sink { [weak self] validate in
                self?.doneBtn.isEnabled = validate
            }.store(in: &cancellables)
    }
    
}

extension ChecklistAddVC {
    
    @objc private func toolbarDoneButtonDidTap() {
        if goalTF.isFirstResponder {
            let row = goalPicker.selectedRow(inComponent: 0)
            if let newGoal = vm.goals[orNil: row] {
                if newGoal != vm.goal {
                    vm.subgoal = nil
                }
                vm.goal = newGoal
            }
            _ = goalTF.resignFirstResponder()
        } else if subgoalTF.isFirstResponder {
            let row = goalPicker.selectedRow(inComponent: 0)
            if let newSubgoal = vm.goal.subgoals[orNil: row] {
                vm.subgoal = newSubgoal
            }
            _ = subgoalTF.resignFirstResponder()
        }
    }
    
    @MainActor
    private func addChecklist() async {
        do {
            Loader.show(in: view)
            try await vm.addChecklist()
            Loader.dismiss()
            Haptic.noti(.success)
            coordinator?.trigger(with: .checklistAddCanceled)
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 체크리스트 추가 실패", message: error.localizedDescription)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ChecklistAddVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == titleTF
    }
    
}

// MARK: - UIPickerViewDataSource

extension ChecklistAddVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == goalPicker ? vm.goals.count : vm.goal.subgoals.count
    }
    
}

// MARK: - UIPickerViewDelegate

extension ChecklistAddVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerView == goalPicker ? vm.goals[row].title : vm.goal.subgoals[row].title
        return NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.pretendard(.medium, 16),
                .foregroundColor: UIColor.colorDark100,
            ]
        )
    }
    
}
