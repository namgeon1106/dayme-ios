//
//  VM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

class VM: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
        Task {
            await fetch()
        }
    }
    
    func bind() {}
    
    func fetch() async {
        
    }
    
}
