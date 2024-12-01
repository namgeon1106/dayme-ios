//
//  SettingVC.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit
import FlexLayout
import PinLayout

#Preview { SettingVC() }

final class SettingVC: VC {
    
    private let userService = UserService()
    private let settings: [Setting] = Setting.allCases
    
    // MARK: UI properties
    
    private let tableView = UITableView()
    private let logoutBtn = FilledButton("로그아웃")
    private let withdrawBtn = FilledButton("회원 탈퇴")
    
    // MARK: Helpers
    
    override func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
    }
    
    override func setupFlex() {
        view.addSubview(flexView)
        flexView.flex.define { flex in
            flex.addItem(tableView).grow(1)
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
}

private extension SettingVC {
    
    @MainActor
    func logout() async {
        Keychain.delete(key: Env.Keychain.accessTokenKey)
        Keychain.delete(key: Env.Keychain.refreshTokenKey)
        coordinator?.trigger(with: .logout)
        Haptic.noti(.success)
    }
    
    @MainActor
    func withdraw() async {
        let title = "회원탈퇴"
        let message = "삭제하시겠습니까?\n모든 정보가 삭제됩니다."
        let selectedAction = await Alert(title: title, message: message)
            .onCancel(title: "취소")
            .onDestructive(title: "탈퇴하기")
            .show(on: self)
        
        if selectedAction == "취소" {
            return
        }
        
        do {
            try await userService.deleteUser()
            coordinator?.trigger(with: .userDeleted)
            Haptic.noti(.success)
        } catch {
            Logger.error(error)
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SettingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let setting = settings[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = setting.title
        content.textProperties.font = .pretendard(.medium, 18)
        content.textProperties.color = .colorDark70
        cell.contentConfiguration = content
        
        if [.version].contains(setting) {
            cell.accessoryType = .none
            Logger.debug(Env.appVersion)
            let label = UILabel("v\(Env.appVersion)")
                .textColor(.colorDark70)
                .font(.pretendard(.medium, 18))
            label.sizeToFit()
            cell.accessoryView = label
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = .colorMain1.withAlphaComponent(0.1)
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        switch setting {
        case .privacyPolicy:
            coordinator?.trigger(with: .termsNeeded(.privacyPolicy))
            
        case .logout:
            Task { await logout() }
            
        case .withdraw:
            Task { await withdraw() }
            
        case .version:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let setting = settings[indexPath.row]
        return ![.version].contains(setting)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
