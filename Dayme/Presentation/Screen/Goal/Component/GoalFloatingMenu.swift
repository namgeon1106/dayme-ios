//
//  GoalFloatingMenu.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import UIKit

enum GoalFloatingMenuItem: CaseIterable {
    case goal
    case subGoal
    case checklist
    
    var title: String {
        switch self {
        case .goal: "주요목표"
        case .subGoal: "세부목표"
        case .checklist: "체크리스트"
        }
    }
}

protocol GoalFloatingMenuDelegate: AnyObject {
    func goalFloatingMenuDidSelect(item: GoalFloatingMenuItem)
}

final class GoalFloatingMenu: UITableView {
    
    weak var menuDelegate: GoalFloatingMenuDelegate?
    
    let items = GoalFloatingMenuItem.allCases
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        
        rowHeight = 50
        showsVerticalScrollIndicator = false
        bounces = false
        register(UITableViewCell.self)
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension GoalFloatingMenu: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(for: indexPath)
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.textProperties.font = .pretendard(.medium, 16)
        content.textProperties.color = .colorDark100
        cell.contentConfiguration = content
        
        let selectedView = UIView()
        selectedView.backgroundColor = .colorMain1.withAlphaComponent(0.1)
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
}

extension GoalFloatingMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        menuDelegate?.goalFloatingMenuDidSelect(item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
