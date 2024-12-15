//
//  SubgoalAddVC.swift
//  Dayme
//
//  Created by 정동천 on 12/14/24.
//

import UIKit
import Combine
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vm = SubgoalAddVM(goal: mockGoals[0])
    return SubgoalAddVC(vm: vm)
}
#endif

final class SubgoalAddVC: VC {
    
    let vm: SubgoalAddVM
    
    // MARK: - UI properties
    
    private let headerLbl = UILabel("세부목표 추가").then {
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
    private let titleTF = BorderedTF("세부목표 제목을 작성해주세요").then {
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
    
    // 상위 목표
    private let goalCaptionLbl = UILabel("상위목표").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private lazy var goalTF = BorderedTF("상위목표 선택").then {
        $0.contentInsets = UIEdgeInsets(0, 12, 0, 6)
        $0.inputView = goalPicker
    }
    private lazy var goalPicker = UIPickerView().then {
        $0.tintColor = .colorMain1
        $0.backgroundColor = .white
        $0.dataSource = self
        $0.delegate = self
    }
    
    // 카테고리
    private let categoryCaptionLbl = UILabel("카테고리").then {
        $0.textColor(.colorGrey50).font(.pretendard(.bold, 14))
    }
    private lazy var categoryCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 6
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoryCell.self)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Lifecycles
    
    init(vm: SubgoalAddVM) {
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
            await self?.addSubgoal()
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
            
            flex.addItem(durationCaptionLbl).marginTop(20)
            
            flex.addItem().direction(.row).marginTop(4).height(51).define { flex in
                flex.addItem(durationStartTF).basis(0%).grow(1)
                
                flex.addItem(durationTildeLbl).margin(0, 4)
                
                flex.addItem(durationEndTF).basis(0%).grow(1)
            }
            
            flex.addItem(goalCaptionLbl).marginTop(20)
            
            flex.addItem(goalTF).marginTop(4).height(51)
            
            flex.addItem(categoryCaptionLbl).marginTop(20)
            
            flex.addItem(categoryCV).marginTop(8).height(33)
            
            flex.addItem().grow(1)
            
            flex.addItem(doneBtn).height(56)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.top().horizontally(8).height(571)
        flexView.flex.layout()
    }
    
    override func bind() {
        vm.$goal.receive(on: RunLoop.main)
            .sink { [weak self] goal in
                self?.goalTF.text = goal.title
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
        
        vm.$category.combineLatest(vm.$categories)
            .receive(on: RunLoop.main)
            .sink { [weak self] category, categories in
                self?.categoryCV.reloadData()
            }.store(in: &cancellables)
        
        vm.$isValidate.receive(on: RunLoop.main)
            .sink { [weak self] validate in
                self?.doneBtn.isEnabled = validate
            }.store(in: &cancellables)
    }
    
}

extension SubgoalAddVC {
    
    private func pickerValueChanged() {
        if durationStartTF.isFirstResponder {
            vm.startDate = datePicker.date
        } else if durationEndTF.isFirstResponder {
            vm.endDate = datePicker.date
        }
    }
    
    @objc private func dateDoneButtonDidTap() {
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
    private func addSubgoal() async {
        do {
            Loader.show(in: view)
            try await vm.addSubgoal()
            Loader.dismiss()
            Haptic.noti(.success)
            coordinator?.trigger(with: .subgoalAddCanceled)
        } catch {
            Loader.dismiss()
            showAlert(title: "🚨 목표 추가 실패", message: error.localizedDescription)
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension SubgoalAddVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
        let category = vm.categories[indexPath.item]
        let isSelected = category == vm.category
        cell.update(category: category, isSelected: isSelected)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension SubgoalAddVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Haptic.impact(.light)
        
        let category = vm.categories[indexPath.item]
        if category == "+" {
            Task {
                if let category = await CategoryPopup.show(on: self) {
                    vm.addCategory(category)
                }
            }
        } else {
            vm.category = category
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension SubgoalAddVC: UITextFieldDelegate {
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == titleTF
    }
    
}

// MARK: - UIPickerViewDataSource

extension SubgoalAddVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        vm.goals.count
    }
    
}

// MARK: - UIPickerViewDelegate

extension SubgoalAddVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(
            string: vm.goals[row].title,
            attributes: [
                .font: UIFont.pretendard(.medium, 16),
                .foregroundColor: UIColor.colorDark100,
            ]
        )
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vm.goal = vm.goals[row]
    }
    
}



final class CategoryPopup: UIAlertController {
    
    var continuation: CheckedContinuation<String?, Never>?
    var textField: UITextField!
    
    static func show(on viewController: UIViewController, animated: Bool = true) async -> String? {
        return await withCheckedContinuation { continuation in
            let alert = CategoryPopup(
                title: "세부목표 추가",
                message: "카테고리",
                preferredStyle: .alert
            )
            alert.setup()
            alert.continuation = continuation
            
            viewController.present(alert, animated: animated)
        }
    }

    private func setup() {
        addTextField { [weak self] textField in
            textField.placeholder = "새로운 카테고리를 입력하세요"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.clearButtonMode = .whileEditing
            self?.textField = textField
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.continuation?.resume(returning: self?.textField.text)
        }
        confirmAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.continuation?.resume(returning: nil)
        }
        
        textField.addAction(UIAction { [weak self] _ in
            confirmAction.isEnabled = !(self?.textField.text ?? "").isEmpty
        }, for: .editingChanged)
        
        addAction(confirmAction)
        addAction(cancelAction)
    }
    
}
