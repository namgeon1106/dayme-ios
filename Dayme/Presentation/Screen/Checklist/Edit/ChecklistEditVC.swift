//
//  ChecklistEditVC.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vm = ChecklistEditVM(goal: mockGoals[0], subgoal: nil, checklist: mockChecklists[0])
    return ChecklistEditVC(vm: vm)
}
#endif

final class ChecklistEditVC: VC {
    
    let vm: ChecklistEditVM
    
    // MARK: - UI properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backBtn = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .colorGrey30
    }
    private let doneBtn = FilledButton("저장하기").then {
        $0.isEnabled = false
    }
    private let deleteBtn = BoarderdButton("삭제하기", color: .colorRed)
    private let bottomContainer = UIView().then {
        $0.backgroundColor = .colorBackground
    }
    
    // 제목
    private let titleCaptionLbl = UILabel("제목").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let titleTF = BorderedTF("체크리스트 제목을 작성해주세요").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.returnKeyType = .next
        $0.clearButtonMode = .whileEditing
    }
    
    private let highGoalCaptionLbl = UILabel("상위목표 설정").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    
    // 주요 목표
    private let goalCaptionLbl = UILabel("주요목표").then {
        $0.textColor(.colorDark70).font(.pretendard(.medium, 16))
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
        $0.textColor(.colorDark70).font(.pretendard(.medium, 16))
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
    
    // 기간
    private let durationCaptionLbl = UILabel("기간").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private lazy var durationStartTF = BorderedTF("시작일").then {
        $0.textAlignment = .center
        $0.inputView = datePicker
        $0.inputAccessoryView = toolbar
    }
    private lazy var durationEndTF = BorderedTF("목표일").then {
        $0.textAlignment = .center
        $0.inputView = datePicker
        $0.inputAccessoryView = toolbar
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
    
    // 반복
    private let repeatCaptionLbl = UILabel("반복").then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let repeatContainer = UIView()
    private var dateItemViews: [ChecklistDateItemView] = []
    
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
    
    init(vm: ChecklistEditVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    override func setup() {
        addKeyboardObeserver()
        
        title = "체크리스트 수정"
        if let naviBar = navigationController?.navigationBar {
            var attributes = naviBar.titleTextAttributes.orEmpty
            attributes[.foregroundColor] = UIColor.colorDark100
            attributes[.font] = UIFont.pretendard(.semiBold, 16)
            naviBar.titleTextAttributes = attributes
        }
        navigationItem.leftBarButtonItem = .init(customView: backBtn)
        view.backgroundColor = .hex("#FBFBFB")
        scrollView.keyboardDismissMode = .interactive
        titleTF.delegate = self
        dateItemViews = vm.weekDays.map(ChecklistDateItemView.init)
        dateItemViews.forEach {
            $0.isSelected = vm.selectedWeekDays.contains($0.weekDay)
            $0.delegate = self
        }
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(doneBtn)
        bottomContainer.addSubview(deleteBtn)
        
        contentView.flex.padding(33, 24).define { flex in
            flex.addItem(titleCaptionLbl)
            
            flex.addItem(titleTF).marginTop(8).height(51)
            
            // 체크리스트 수정 API >> 목표 수정 미구현으로 임시 제한
//            flex.addItem(highGoalCaptionLbl).marginTop(24).height(32)
//            
//            flex.addItem(goalCaptionLbl).marginTop(20)
//            
//            flex.addItem(goalTF).marginTop(8).height(51)
//            
//            flex.addItem(subgoalCaptionLbl).marginTop(20)
//            
//            flex.addItem(subgoalTF).marginTop(8).height(51)
            
            flex.addItem(durationCaptionLbl).marginTop(24).height(32)
            
            flex.addItem().direction(.row).marginTop(8).height(51).define { flex in
                flex.addItem(durationStartTF).basis(0%).grow(1)
                
                flex.addItem(durationTildeLbl).margin(0, 4)
                
                flex.addItem(durationEndTF).basis(0%).grow(1)
            }
            
            flex.addItem(repeatCaptionLbl).marginTop(24).height(32)
            
            flex.addItem(repeatContainer).direction(.row).marginTop(8).height(49).define { flex in
                for itemView in dateItemViews {
                    flex.addItem(itemView).basis(0%).grow(1).marginHorizontal(4)
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
        
        let spacing: CGFloat = 8
        let bottomInset = view.safeAreaInsets.bottom
        let buttonHeight: CGFloat = 56
        let containerHeight = buttonHeight * 2 + bottomInset + spacing * 3
        bottomContainer.pin.horizontally().bottom().height(containerHeight)
        
        deleteBtn.pin.bottom(bottomInset + spacing)
            .horizontally(24).height(buttonHeight)
        doneBtn.pin.above(of: deleteBtn).marginBottom(spacing)
            .horizontally(24).height(buttonHeight)
        scrollView.contentInset.bottom = containerHeight
    }
    
    override func setupAction() {
        backBtn.onAction { [weak self] in
            self?.coordinator?.trigger(with: .checklistEditCanceled)
        }
        
        titleTF.onAction { [weak self] in
            guard let self else { return }
            vm.title = titleTF.text.orEmpty
        }
        
        subgoalTF.onAction(for: .editingDidBegin) { [weak self] in
            self?.vm.subgoal = nil
        }
        
        durationStartTF.onAction(for: .editingDidBegin) { [weak self] in
            guard let self else { return }
            
            Haptic.impact(.light)
            
            datePicker.minimumDate = nil
            if vm.startDate == nil {
                vm.startDate = datePicker.date
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
        }
        
        datePicker.onAction(for: .valueChanged) { [weak self] in
            self?.pickerValueChanged()
        }
        
        doneBtn.onAction { [weak self] in
            await self?.editChecklist()
        }
        
        deleteBtn.onAction { [weak self] in
            await self?.deleteChecklist()
        }
    }
    
    override func bind() {
        vm.$title.receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.titleTF.text = title
            }.store(in: &cancellables)
        
        vm.$goal.receive(on: RunLoop.main)
            .sink { [weak self] goal in
                self?.goalTF.text = goal.title
            }.store(in: &cancellables)
        
        vm.$subgoal.receive(on: RunLoop.main)
            .sink { [weak self] subgoal in
                self?.subgoalTF.text = subgoal?.title
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
        
        vm.$selectedWeekDays.receive(on: RunLoop.main)
            .sink { [weak self] selectedWeekDays in
                self?.dateItemViews.forEach {
                    $0.isSelected = selectedWeekDays.contains($0.weekDay)
                }
            }.store(in: &cancellables)
        
        vm.$isValidate.receive(on: RunLoop.main)
            .sink { [weak self] validate in
                self?.doneBtn.isEnabled = validate
            }.store(in: &cancellables)
    }
    
    override func keyboardWillShow(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction) {
            self.scrollView.contentInset.bottom = height
        }
    }
    
    override func keyboardWillHide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction) {
            self.scrollView.contentInset.bottom = 0
        }
    }
    
}

extension ChecklistEditVC {
    
    private func pickerValueChanged() {
        if durationStartTF.isFirstResponder {
            vm.startDate = datePicker.date
        } else if durationEndTF.isFirstResponder {
            vm.endDate = datePicker.date
        }
    }
    
    @objc private func toolbarDoneButtonDidTap() {
        if durationStartTF.isFirstResponder {
            if vm.endDate == nil {
                _ = durationEndTF.becomeFirstResponder()
            } else {
                _ = durationStartTF.resignFirstResponder()
            }
        } else if durationEndTF.isFirstResponder {
            _ = durationEndTF.resignFirstResponder()
        } else if goalTF.isFirstResponder {
            let row = goalPicker.selectedRow(inComponent: 0)
            if let newGoal = vm.goals[orNil: row] {
                if newGoal != vm.goal {
                    vm.subgoal = nil
                }
                vm.goal = newGoal
            }
            _ = goalTF.resignFirstResponder()
        } else if subgoalTF.isFirstResponder {
            let row = subgoalPicker.selectedRow(inComponent: 0)
            if let newSubgoal = vm.goal.subgoals[orNil: row] {
                vm.subgoal = newSubgoal
            }
            _ = subgoalTF.resignFirstResponder()
        }
    }
    
    @MainActor
    private func editChecklist() async {
        do {
            Loader.show(in: view)
            try await vm.editChecklist()
            Loader.dismiss()
            Haptic.noti(.success)
            coordinator?.trigger(with: .checklistEditCanceled)
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 체크리스트 수정 실패", message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func deleteChecklist() async {
        do {
            Loader.show(in: view)
            try await vm.deleteChecklist()
            Loader.dismiss()
            Haptic.noti(.success)
            coordinator?.trigger(with: .checklistEditCanceled)
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 체크리스트 삭제 실패", message: error.localizedDescription)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChecklistEditVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == titleTF
    }
    
}

// MARK: - UIPickerViewDataSource

extension ChecklistEditVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView == goalPicker ? vm.goals.count : vm.goal.subgoals.count
    }
    
}

// MARK: - UIPickerViewDelegate

extension ChecklistEditVC: UIPickerViewDelegate {
    
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

extension ChecklistEditVC: ChecklistDateItemViewDelegate {
    
    func checklistDateItemViewDidTap(_ view: ChecklistDateItemView) {
        Haptic.impact(.light)
        
        let weekDay = view.weekDay
        if vm.selectedWeekDays.contains(weekDay) {
            vm.selectedWeekDays.remove(weekDay)
        } else {
            vm.selectedWeekDays.insert(weekDay)
        }
    }
    
}
