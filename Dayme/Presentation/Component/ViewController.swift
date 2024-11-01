//
//  ViewController.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit

class VC: UIViewController {
    
    let flexView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupFlex()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutFlex()
    }
    
    func setup() {}
    func setupFlex() {}
    func layoutFlex() {}
}
