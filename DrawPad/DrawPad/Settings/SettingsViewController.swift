import UIKit

protocol SettingsViewControllerDelegate {

    func updateWidth(with value: CGFloat)
    func updateOpacity(with value: CGFloat)
    func settingsWillClose()

}
class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsView: UIView!

    @IBOutlet private weak var brushWidthStepper: UIStepper!
    @IBOutlet private weak var widthValueLabel: UILabel!

    @IBOutlet private weak var brushOpacityStepper: UIStepper!
    @IBOutlet private weak var opacityValueLabel: UILabel!

    @IBOutlet private weak var exampleImageView: UIImageView!

    var delegate: SettingsViewControllerDelegate?
    var selectedColor: UIColor?

    var brush: (CGFloat, CGFloat) {
        get {
            return (CGFloat(brushWidthStepper.value), CGFloat(brushOpacityStepper.value) / 100)
        }
        set {
            initialBrushWidth = newValue.0
            initialBrushOpacity = newValue.1
        }
    }

    private var initialBrushWidth: CGFloat!
    private var initialBrushOpacity: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeSettings(_:)))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)

        brushWidthStepper.value = Double(initialBrushWidth)
        brushOpacityStepper.value = Double(initialBrushOpacity)
        widthValueLabel.text = "\(brush.0)px"
        opacityValueLabel.text = "\(brush.1 * 100)%"
        drawExample()

        configure(view: brushWidthStepper, cornerRadius: 10)
        configure(view: brushOpacityStepper, cornerRadius: 10)
        configure(view: exampleImageView)
        configure(view: settingsView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        delegate?.settingsWillClose()
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

    private func drawExample() {
        UIGraphicsBeginImageContext(exampleImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setLineCap(.round)
        context.setLineWidth(brush.0)
        let color = selectedColor?.cgColor ?? UIColor.black.cgColor
        context.setStrokeColor(color)
        context.setAlpha(brush.1)

        context.move(to: CGPoint(x: 30, y: 30))
        context.addLine(to: CGPoint(x: 30, y: 30))
        context.strokePath()
        exampleImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    @objc
    private func closeSettings(_ gestureRecognizer: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func widthChanged(_ sender: Any) {
        delegate?.updateWidth(with: brush.0)
        widthValueLabel.text = "\(brush.0)px"
        drawExample()
    }

    @IBAction func opacityChanged(_ sender: Any) {
        delegate?.updateOpacity(with: brush.1)
        opacityValueLabel.text = "\(brush.1 * 100)%"
        drawExample()
    }
}

extension SettingsViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return true
        }

        if touchView.isDescendant(of: settingsView) {
            return false
        }

        return true
    }

}
