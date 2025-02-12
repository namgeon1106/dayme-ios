//
//  SettingVC.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit
import FlexLayout
import PinLayout
import MessageUI

#if DEBUG
#Preview {
    UINavigationController(rootViewController: SettingVC())
}
#endif

final class SettingVC: VC {
    
    private let vm = SettingVM()
    private let settings: [Setting] = Setting.allCases
    
    
    // MARK: UI properties
    
    private let timo = UIImageView(image: .timoFace).then {
        $0.contentMode = .scaleAspectFit
    }
    private let titleLbl = UILabel("설정").then {
        $0.textColor(.colorDark100).font(.pretendard(.bold, 20))
    }
    private let nicknameLbl = UILabel().then {
        $0.textColor(.colorDark100).font(.pretendard(.semiBold, 16))
    }
    private let headerView = UIView()
    private let tableView = UITableView()

    
    
    // MARK: Helpers
    
    override func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        headerView.frame.size.height = 183
        
        navigationItem.leftBarButtonItem = .init(customView: titleLbl)
    }
    
    override func setupFlex() {
        view.addSubview(tableView)
        
        headerView.addSubview(flexView)
        flexView.flex.define { flex in
            flex.addItem().grow(1).justifyContent(.center).alignItems(.center).define { flex in
                flex.addItem(CircleView())
                    .width(100)
                    .height(100)
                    .backgroundColor(.colorMain1)
                    .alignItems(.center)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(timo).height(74%)
                    }
                
                flex.addItem(nicknameLbl).marginTop(12)
            }
            
            flex.addItem().height(8).marginBottom(9).backgroundColor(.colorGrey10)
        }
    }
    
    override func layoutFlex() {
        tableView.pin.all()
        flexView.pin.all()
        flexView.flex.layout()
    }
    
    override func bind() {
        vm.$nickname.receive(on: RunLoop.main)
            .sink { [weak self] nickname in
                self?.nicknameLbl.text = nickname
                self?.nicknameLbl.flex.markDirty()
                self?.flexView.flex.layout()
            }.store(in: &cancellables)
    }
    
}

private extension SettingVC {
    
    @MainActor
    func logout() async {
        try? await vm.logout()
        coordinator?.trigger(with: .logout)
        Haptic.noti(.success)
    }
    
    @MainActor
    func withdraw() async {
        let selectedAction = await CustomConfirmAlert(
            title: "회원탈퇴",
            message: "삭제하시겠습니까?\n모든 정보가 삭제됩니다.",
            primaryTitle: "탈퇴",
            isCancellable: true
        ).show(on: self)
        
        if selectedAction == .cancel {
            return
        }
        
        do {
            try await vm.deleteUser()
            coordinator?.trigger(with: .userDeleted)
            Haptic.noti(.success)
        } catch {
            Logger.error(error)
            showAlert(title: "🚨 회원탈퇴 실패", message: error.localizedDescription)
        }
    }
    
    func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            composeViewController.setToRecipients(["dayme.note24@gmail.com"])
            composeViewController.setSubject("[DAYME 문의]")
            composeViewController.setMessageBody("", isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
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
        content.textProperties.font = .pretendard(.medium, 14)
        content.textProperties.color = .colorDark70
        cell.contentConfiguration = content
        
        if [.version].contains(setting) {
            cell.accessoryType = .none
            Logger.debug(Env.appVersion)
            let label = UILabel("v\(Env.appVersion)")
                .textColor(.colorDark70)
                .font(.pretendard(.medium, 14))
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
        
        case .sendFeedback:
            sendFeedback()
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
        44
    }
    
}

extension SettingVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
