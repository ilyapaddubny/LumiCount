//
//  Extensions.swift
//  CountMate
//
//  Created by Ilya Paddubny on 24.05.2023.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()

    func reset() {
        path = NavigationPath()
    }
}

enum FieldsError {
    case emptyTitle
    case zeroAim
    case zeroStep
}

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
    
    func black36() -> Text {
        self
            .foregroundColor(Color.black)
            .font(.custom("LeagueSpartan-Regular", size: 36))
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
    
    func redRegular(size: CGFloat) -> Text {
        self
            .foregroundColor(Color.red)
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

//let colorMapping: [String: Color] = [
//    "white": .white,
//    "red": .red,
//    "blue": .blue,
//    // Add more color mappings as needed
//]

extension Color: Decodable {
    private enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(CGFloat.self, forKey: .red)
        let green = try container.decode(CGFloat.self, forKey: .green)
        let blue = try container.decode(CGFloat.self, forKey: .blue)
        
        self.init(red: Double(red), green: Double(green), blue: Double(blue))
    }
}

//      23/07

//extension Encodable {
//    /// Cast a data to a dictionary
//    ///
//    /// - returns: A new `Dictionary [String: Any]`.
//    func asDictionary() -> [String: Any] {
//        guard let data = try? JSONEncoder().encode(self) else {
//            return [:]
//        }
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
//            return json ?? [:]
//        } catch {
//            return [:]
//        }
//    }
//}

extension CGSize: Hashable {
//    This implementation combines the hash values of the width and height properties of the CGSize instance using the hasher.combine method, which is required by the Hashable protocol. With this extension in place, you should be able to use CGSize instances with the combine method of the Hasher class without any issues.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

extension Goal {
    /// Calculates a persentage of aim complition
    ///
    /// - returns: A `Double` from 0 to 1.
   
//    var backgroundHeight: Double {
//            return Double(currentNumber) / Double(aim)
//        }
    
    var backgroundHeight: CGSize {
            return CGSize(width: 0.5, height: Double(currentNumber) / Double(aim))
        }
    
    
//    func addStep() {
////        This function adds a step to the currentNumber on pluss button pressed
//        currentNumber += step
        
//    }
    
}
