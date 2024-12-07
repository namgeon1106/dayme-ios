//
//  PalleteView.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

protocol PalleteViewDelegate: AnyObject {
    func palleteViewDidSelect(_ color: PalleteColor)
}

final class PalleteView: Vue {
    
    weak var delegate: PalleteViewDelegate?
    
    var selectedColor: PalleteColor? {
        didSet {
            for (color, button) in zip(pallete, buttons) {
                let image: UIImage = color == selectedColor ? .icRadioOn : .icRadioOff
                button.setImage(image, for: .normal)
            }
        }
    }
    
    private let pallete: [PalleteColor] = PalleteColor.allCases
    
    private lazy var buttons: [UIButton] = pallete.map { color in
        let button = UIButton()
        button.setImage(.icRadioOff, for: .normal)
        button.tintColor = .hex(color.hex)
        return button
    }
    
    override func setupAction() {
        for (color, button) in zip(pallete, buttons) {
            button.onAction { [weak self] in
                self?.delegate?.palleteViewDidSelect(color)
            }
        }
    }
    
    override func setupFlex() {
        addSubview(flexView)
        
        flexView.flex.direction(.row).height(44).define { flex in
            for button in buttons {
                flex.addItem(button).width(44)
            }
        }
    }
    
    override func layoutFlex() {
        flexView.pin.all()
        flexView.flex.layout()
    }
    
}
