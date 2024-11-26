//
//  Font.swift
//  Dayme
//
//  Created by 정동천 on 11/26/24.
//

import UIKit

extension UIFont {
    
    static func montserrat(_ weight: Font.Montserrat, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
    
    static func pretendard(_ weight: Font.Pretendard, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
    
}

enum Font {}

extension Font {
    enum Montserrat: String {
        case thin = "Montserrat-Thin"
        case extraLight = "Montserrat-ExtraLight"
        case light = "Montserrat-Light"
        case regular = "Montserrat-Regular"
        case medium = "Montserrat-Medium"
        case semiBold = "Montserrat-SemiBold"
        case bold = "Montserrat-Bold"
        case extraBold = "Montserrat-ExtraBold"
        case black = "Montserrat-Black"
    }
}

extension Font {
    enum Pretendard: String {
        case thin = "PretendardVariable-Thin"
        case extraLight = "PretendardVariable-ExtraLight"
        case light = "PretendardVariable-Light"
        case regular = "PretendardVariable-Regular"
        case medium = "PretendardVariable-Medium"
        case semiBold = "PretendardVariable-SemiBold"
        case bold = "PretendardVariable-Bold"
        case extraBold = "PretendardVariable-ExtraBold"
        case black = "PretendardVariable-Black"
    }
}
