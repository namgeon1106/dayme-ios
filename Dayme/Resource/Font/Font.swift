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
        /// 100
        case thin = "Montserrat-Thin"
        /// 200
        case extraLight = "Montserrat-ExtraLight"
        /// 300
        case light = "Montserrat-Light"
        /// 400
        case regular = "Montserrat-Regular"
        /// 500
        case medium = "Montserrat-Medium"
        /// 600
        case semiBold = "Montserrat-SemiBold"
        /// 700
        case bold = "Montserrat-Bold"
        /// 800
        case extraBold = "Montserrat-ExtraBold"
        /// 900
        case black = "Montserrat-Black"
    }
}

extension Font {
    enum Pretendard: String {
        /// 100
        case thin = "PretendardVariable-Thin"
        /// 200
        case extraLight = "PretendardVariable-ExtraLight"
        /// 300
        case light = "PretendardVariable-Light"
        /// 400
        case regular = "PretendardVariable-Regular"
        /// 500
        case medium = "PretendardVariable-Medium"
        /// 600
        case semiBold = "PretendardVariable-SemiBold"
        /// 700
        case bold = "PretendardVariable-Bold"
        /// 800
        case extraBold = "PretendardVariable-ExtraBold"
        /// 900
        case black = "PretendardVariable-Black"
    }
}
