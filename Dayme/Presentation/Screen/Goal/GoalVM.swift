//
//  GoalVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class GoalVM: VM {
    @Published var isMenuHidden: Bool = true
    @Published var isFABHidden: Bool = true
    
    private let service: GoalService = .shared
    
    
    override func bind() {
        service.goals.map(\.isEmpty)
            .sink { [weak self] isEmpty in
                self?.isFABHidden = isEmpty
            }.store(in: &cancellables)
    }
}
