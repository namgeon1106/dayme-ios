//
//  GoalListVC.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit
import FlexLayout
import PinLayout

#Preview {
    let vc = GoalListVC()
    #if DEBUG
    vc.goals = mockGoals
    #endif
    return vc
}

final class GoalListVC: UITableViewController {
    
    var goals: [Goal] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
    }
    
}

// MARK: - UITableViewDataSource

extension GoalListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalListCell = tableView.dequeueReusableCell(for: indexPath)
        cell.bind(goals[indexPath.row])
        return cell
    }
    
}
