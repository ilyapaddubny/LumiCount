//
//  Extensions.swift
//  CountMate
//
//  Created by Ilya Paddubny on 24.05.2023.
//

import SwiftUI

protocol CustomField {
    var fieldHeight: CGFloat {get}
}

extension CustomField {
    var fieldHeight: CGFloat {
        return CGFloat(43)
    }
}

extension Color {
    static let backgroundBottom = Color("BackgroundBottom")
    static let backgroundTop = Color("BackgroundTop")
    
    //    colors for the background of a GoalViews
    static let customRed = Color("CustomRed")
    static let customOrange = Color("CustomOrange")
    static let customYellow = Color("CustomYellow")
    static let customGreenShamrock = Color("CustomGreenShamrock")
    static let customBlueAqua = Color("CustomBlueAqua")
    static let customPurple = Color("CustomPurple")
    static let customPink = Color("CustomPink")
    static let customGray = Color("CustomGray")
    
    static let customBlueDodger = Color("CustomBlueDodger")
    static let customGreenEmerald = Color("CustomGreenEmerald")
    static let customBackgroundWhite = Color("CustomBackgroundWhite")
    
    func getStringName() -> String {
        switch self {
        case Color.customRed:
            return "CustomRed"
        case Color.customOrange:
            return "CustomOrange"
        case Color.customYellow:
            return "CustomYellow"
        case Color.customGreenShamrock:
            return "CustomGreenShamrock"
        case Color.customBlueAqua:
            return "CustomBlueAqua"
        case Color.customPurple:
            return "CustomPurple"
        case Color.customPink:
            return "CustomPink"
        case Color.customGray:
            return "CustomGray"
        case Color.customBlueDodger:
            return "CustomBlueDodger"
        case Color.customGreenEmerald:
            return "CustomGreenEmerald"
        case Color.customBackgroundWhite:
            return "CustomBackgroundWhite"
        default:
            return Color.white.description
        }
        
    }
}


extension Text {
    
    func gray18() -> Text {
        self
            .foregroundColor(Color.gray.opacity(0.8))
            .font(.custom("LeagueSpartan-Regular", size: 18))
    }
    
    func black18() -> Text {
        self
            .foregroundColor(Color.black)
            .font(.custom("LeagueSpartan-Regular", size: 18))
    }
    
    
    func blackExtraLight(size: CGFloat) -> Text {
        self
            .foregroundColor(Color.black)
            .font(.custom("LeagueSpartan-ExtraLight", size: size))
    }
    
    func blackRegular(size: CGFloat) -> Text {
        self
            .foregroundColor(Color.black)
            .font(.custom("LeagueSpartan-Regular", size: size))
    }
    
    
    func white22() -> Text {
        self
            .foregroundColor(Color.white)
            .font(.custom("LeagueSpartan-Regular", size: 22))
    }
    
}

extension TextField {
    func rightAlignment() -> some View {
        self
            .foregroundColor(Color.customGray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .multilineTextAlignment(.trailing)
            .padding(.trailing)
    }
}



