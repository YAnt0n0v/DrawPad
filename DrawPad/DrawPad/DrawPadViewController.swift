import UIKit

struct Tool {

    enum ToolType {
        case brush
        case rubber
        case squareDrawer
        case triangleDrawer
        case circleDrawer
    }

    let icon: UIImage
    let title: String
    let type: ToolType
}

class DrawPadViewController: UIViewController {

    @IBOutlet weak var toolsCollectionView: UICollectionView!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var instrumnetsPanelView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet var shapesButtons: [UIButton]!


    private var selectedColor: UIColor? = .black {
        didSet {
            if selectedColor != oldValue {
                colorPickerButton.tintColor = selectedColor
            }
        }
    }
    private let tools = ToolsCollection()
    private var selectedTool: Tool.ToolType = .brush {
        didSet {
            if selectedTool != oldValue {
                switch oldValue {
                    case .brush,
                         .rubber:
                        break

                    case .squareDrawer,
                         .triangleDrawer,
                         .circleDrawer:
                        removeShape()
                }
                switch selectedTool {
                    case.rubber:
                        opacity = 1.0
                        isDrawable = true

                    case .squareDrawer,
                         .triangleDrawer,
                         .circleDrawer:
                        isDrawable = false

                    case .brush:
                        isDrawable = true
                }
            }
        }
    }
    private var isDrawable = true
    private let shapeLayerFactory = ShapeLayerFactory()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private var editableShape: CAShapeLayer? {
        didSet {
            guard let shape = editableShape else {
                return
            }
            containerView.layer.addSublayer(shape)
            shape.frame = containerView.bounds
            shapesButtons.forEach{ $0.isHidden = false }
        }
    }
    private var shapeScale: CGFloat = 1.0
    private var shapeRotation: CGFloat = 0.0

    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        toolsCollectionView.selectItem(at: NSIndexPath(row: 0, section: 0) as IndexPath,
                                       animated: true,
                                       scrollPosition: [])

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scaleShape(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveShape(_:)))

        containerView.addGestureRecognizer(pinchGestureRecognizer)
        containerView.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        shapesButtons.forEach{ configure(view: $0, cornerRadius: 10) }
        configure(view: settingsButton, cornerRadius: 10)
        configure(view: colorPickerButton, cornerRadius: 10)
        configure(view: instrumnetsPanelView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "drawPadToColorPickerSegue" {
            guard let destination = segue.destination as? ColorPickerViewController else {
                return
            }

            destination.delegate = self
            destination.selectedColor = selectedColor
            isDrawable = false
        }
        else if segue.identifier == "drawPadToSettingsSegue" {
            guard let destination = segue.destination as? SettingsViewController else {
                return
            }

            destination.delegate = self
            destination.brush = (brushWidth, opacity * 100)
            destination.selectedColor = selectedColor
            isDrawable = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isDrawable else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, isDrawable else {
            return
        }

        swiped = true
        let currentPoint = touch.location(in: view)
        drawLine(from: lastPoint, to: currentPoint)

        lastPoint = currentPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawable else {
            return
        }

        if !swiped {
            drawLine(from: lastPoint, to: lastPoint)
        }

        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        tempImageView.image = nil
    }

    private func configure(view: UIView, cornerRadius: CGFloat = 20) {
        view.layer.cornerRadius = cornerRadius
        configureShadow(for: view)
    }

    private func configureShadow(for view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.5
    }

    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        tempImageView.image?.draw(in: view.bounds)

        context.move(to: fromPoint)
        context.addLine(to: toPoint)

        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)

        let color = selectedTool == .rubber
            ? UIColor.white.cgColor
            : selectedColor?.cgColor ?? UIColor.black.cgColor
        context.setStrokeColor(color)

        context.strokePath()

        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }

    private func removeShape() {
        editableShape?.removeFromSuperlayer()
        editableShape = nil
        shapesButtons.forEach{ $0.isHidden = true }
        isDrawable = true
        toolsCollectionView.selectItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: true, scrollPosition: [])
        shapeScale = 1.0
    }

    @IBAction private func openColorPicker() {
        performSegue(withIdentifier: "drawPadToColorPickerSegue", sender: nil)
    }

    @IBAction private func openSettings() {
        performSegue(withIdentifier: "drawPadToSettingsSegue", sender: nil)
    }

    @IBAction func acceptShape(_ sender: Any) {
        guard let shape = editableShape,
              let cgPath = shape.path else {
            removeShape()
            return
        }

        let path = UIBezierPath(cgPath: cgPath)
        UIGraphicsBeginImageContext(view.frame.size)
        tempImageView.image?.draw(in: view.bounds)
        (selectedColor ?? .black).setStroke()
        path.lineWidth = brushWidth * shapeScale

        path.apply(CGAffineTransform(translationX: containerView.center.x - 100 * shapeScale,
                                     y: containerView.center.y - 100 * shapeScale).scaledBy(x: shapeScale, y: shapeScale))

        path.stroke()
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()

        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()

        removeShape()
    }

    @IBAction func declineShape(_ sender: Any) {
        removeShape()
    }

    @objc
    func rotateShape(_ gestureRecognizer: UIRotationGestureRecognizer) {
        editableShape?.setAffineTransform(CGAffineTransform(rotationAngle: gestureRecognizer.rotation).scaledBy(x: shapeScale,
                                                                                                                y: shapeScale))
        shapeRotation = gestureRecognizer.rotation
    }

    @objc
    func scaleShape(_ gestureRecognizer: UIPinchGestureRecognizer) {
        editableShape?.setAffineTransform(CGAffineTransform(scaleX: gestureRecognizer.scale,
                                                            y: gestureRecognizer.scale).rotated(by: shapeRotation))
        shapeScale = gestureRecognizer.scale
    }

    @objc
    func moveShape(_ gestureRecognizer: UIPanGestureRecognizer) {
        let containerView = gestureRecognizer.view!
        let point = gestureRecognizer.translation(in: view)
        containerView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
    }

}

extension DrawPadViewController: DrawPadColorPickerViewControllerDelegate {

    func update(with color: UIColor?) {
        selectedColor = color

        switch selectedTool {
            case .brush,
                 .rubber:
                isDrawable = true
            case .squareDrawer,
                 .triangleDrawer,
                 .circleDrawer:
                isDrawable = false
        }
    }

}

extension DrawPadViewController: ToolPanelDelegate {

    func toolUpdated(to tool: Tool.ToolType) {
        selectedTool = tool

        containerView.frame = CGRect(x: view.frame.width/2 - 100, y: view.frame.height/2 - 100, width: 200, height: 200)
        view.addSubview(containerView)
        switch tool {
            case .brush,
                 .rubber:
                containerView.removeFromSuperview()
                return

            case .squareDrawer:
                editableShape = shapeLayerFactory.drawRectangle(with: selectedColor ?? .black, brushWidth: brushWidth)

            case .triangleDrawer:
                editableShape = shapeLayerFactory.drawTriangle(with: selectedColor ?? .black, brushWidth: brushWidth)

            case .circleDrawer:
                editableShape = shapeLayerFactory.drawOval(with: selectedColor ?? .black, ovalIn: containerView.bounds, brushWidth: brushWidth)
        }
    }

}

extension DrawPadViewController: SettingsViewControllerDelegate {

    func updateWidth(with value: CGFloat) {
        brushWidth = value
    }

    func updateOpacity(with value: CGFloat) {
        opacity = value
    }

    func settingsWillClose() {
        isDrawable = true
    }

}

extension DrawPadViewController: UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToolCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ToolCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let tool = tools[indexPath.row] else {
            return UICollectionViewCell()
        }
        cell.configure(with: tool)
        cell.delegate = self

        return cell
    }

}

extension DrawPadViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}
