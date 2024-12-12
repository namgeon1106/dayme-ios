//
//  GoalListVC.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit
import FlexLayout
import PinLayout

#if DEBUG
#Preview {
    let vc = GoalListVC()
    vc.goals = mockGoals
    return vc
}
#endif

final class GoalListVC: UITableViewController {
    
    weak var cellDelegate: GoalListCellDelegate?
    
    var goals: [Goal] = [] {
        didSet {
            homeGoals = goals.filter { $0.displayHome }
            etcGoals = goals.filter { !$0.displayHome }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var homeGoals: [Goal] = []
    private var etcGoals: [Goal] = []
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setup() {
        tableView.register(GoalListCell.self)
        tableView.separatorStyle = .none
        tableView.rowHeight = 110
        tableView.tableHeaderView = UIView()
        tableView.tableHeaderView?.frame.size.height = 24
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.frame.size.height = 24
        tableView.sectionHeaderTopPadding = 0
    }
    
}

// MARK: - UITableViewDataSource

extension GoalListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? homeGoals.count : etcGoals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goal = indexPath.section == 0 ? homeGoals[indexPath.row] : etcGoals[indexPath.row]
        let cell: GoalListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(goal)
        cell.delegate = cellDelegate
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension GoalListVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = indexPath.section == 0 ? homeGoals[indexPath.row] : etcGoals[indexPath.row]
        cellDelegate?.goalListCellDidSelect(goal)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if homeGoals.isEmpty {
            return nil
        }
        
        let container = UIView()
        
        if section == 0 {
            let label = UILabel("홈화면 표시")
                .textColor(.colorGrey50)
                .font(.pretendard(.bold, 14))
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24),
            ])
        } else {
            if etcGoals.isEmpty {
                return nil
            }
            
            let separator = UIView().backgroundColor(.colorGrey20)
            separator.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(separator)
            NSLayoutConstraint.activate([
                separator.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 24),
                separator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -24),
                separator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                separator.heightAnchor.constraint(equalToConstant: 2),
            ])
        }
        
        return container
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if homeGoals.isEmpty {
            return 0
        }
        
        if section == 0 {
            return 24
        } else {
            return etcGoals.isEmpty ? 0 : 32
        }
    }
    
}
