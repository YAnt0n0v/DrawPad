import UIKit
import Foundation

fileprivate enum RawTool: CaseIterable {
    case brush
    case rubber
    case square
    case triangle
    case circle
}

extension RawTool: RawRepresentable {

    typealias RawValue = Tool

    var rawValue: RawValue {
        switch self {
            case .brush:
                return Tool(icon: UIImage(named: "brush")!, title: "Brush", type: .brush)
            case .rubber:
                return Tool(icon: UIImage(named: "rubber")!, title: "Rubber", type: .rubber)
            case .square:
                return Tool(icon: UIImage(named: "square")!, title: "Square", type: .squareDrawer)
            case .triangle:
                return Tool(icon: UIImage(named: "triangle")!, title: "Triangle", type: .triangleDrawer)
            case .circle:
                return Tool(icon: UIImage(named: "circle")!, title: "Circle", type: .circleDrawer)
        }
    }

    init?(rawValue: Tool) {
        switch rawValue.type {
            case .brush:
                self = .brush
            case .rubber:
                self = .rubber
            case .squareDrawer:
                self = .square
            case .triangleDrawer:
                self = .triangle
            case .circleDrawer:
                self = .circle
        }
    }

}

class ToolsCollection {

    private var tools: [Tool] {
        return RawTool.allCases.map{ $0.rawValue }
    }

    var count: Int {
        return tools.count
    }

    subscript(index: Int) -> Tool? {
        return index < tools.count ? tools[index] : nil
    }

}
