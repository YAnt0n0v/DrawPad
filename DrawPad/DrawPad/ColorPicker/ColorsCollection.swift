import UIKit
import Foundation

enum RawColor: CaseIterable {
    case black
    case gray
    case brown
    case cantaloupe
    case orange
    case yellow
    case asparagus
    case green
    case teal
    case sky
    case blue
    case purple
    case magenta
    case pink
    case red
    case cayenne
}

extension RawColor: RawRepresentable {

    typealias RawType = UIColor

    var rawValue: UIColor {
        switch self {
            case .black:
                return UIColor.black
            case .gray:
                return UIColor.gray
            case .brown:
                return UIColor.brown
            case .red:
                return UIColor.red
            case .pink:
                return UIColor.systemPink
            case .purple:
                return UIColor.purple
            case .yellow:
                return UIColor.yellow
            case .orange:
                return UIColor.orange
            case .asparagus:
                return UIColor(red: 146 / 255, green: 144 / 255, blue: 0, alpha: 1)
            case .green:
                return UIColor.green
            case .blue:
                return UIColor.blue
            case .sky:
                return UIColor(red: 118 / 255, green: 214 / 255, blue: 255 / 255, alpha: 1)
            case .teal:
                return UIColor(red: 0, green: 145 / 255, blue: 147 / 255, alpha: 1)
            case .magenta:
                return UIColor(red: 255 / 255, green: 64 / 255, blue: 255 / 255, alpha: 1)
            case .cantaloupe:
                return UIColor(red: 255 / 255, green: 212 / 255, blue: 121 / 255, alpha: 1)
            case .cayenne:
                return UIColor(red: 148 / 255, green: 17 / 255, blue: 0, alpha: 1)
        }
    }

    init?(rawValue: UIColor) {
        switch rawValue {
            case .black:
                self = .black
            case .gray:
                self = .gray
            case .brown:
                self = .brown
            case .red:
                self = .red
            case .systemPink:
                self = .pink
            case .purple:
                self = .purple
            case .yellow:
                self = .yellow
            case .orange:
                self = .orange
            case UIColor(red: 142, green: 250, blue: 0, alpha: 1):
                self = .asparagus
            case .green:
                self = .green
            case .blue:
                self = .blue
            case UIColor(red: 118, green: 214, blue: 255, alpha: 1):
                self = .sky
            case UIColor(red: 0, green: 145, blue: 147, alpha: 1):
                self = .teal
            case UIColor(red: 255, green: 64, blue: 255, alpha: 1):
                self = .magenta
            case UIColor(red: 255, green: 212, blue: 121, alpha: 1):
                self = .cantaloupe
            case UIColor(red: 148, green: 17, blue: 0, alpha: 1):
                self = .cayenne
            default:
                return nil
        }
    }

}

class ColorsCollection {

    private var colors: [UIColor] {
        return RawColor.allCases.map{ $0.rawValue }
    }

    subscript(index: Int) -> UIColor? {
        return index < colors.count ? colors[index] : nil
    }

}
