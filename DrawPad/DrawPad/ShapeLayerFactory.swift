import UIKit
import Foundation

enum Shape {
    case rectangle
    case triangle
    case circle
}

class ShapeLayerFactory {

    func drawRectangle(with color: UIColor, brushWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 0))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = brushWidth
        shapeLayer.bounds = path.cgPath.boundingBox

        return shapeLayer
    }

    func drawTriangle(with color: UIColor, brushWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 200))
        path.addLine(to: CGPoint(x: 100, y: 0))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 0, y: 200))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = brushWidth
        shapeLayer.bounds = path.cgPath.boundingBox

        return shapeLayer
    }

    func drawOval(with color: UIColor, ovalIn: CGRect, brushWidth: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(ovalIn: ovalIn)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = brushWidth
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.bounds = path.cgPath.boundingBox

        return shapeLayer
    }
    
}
