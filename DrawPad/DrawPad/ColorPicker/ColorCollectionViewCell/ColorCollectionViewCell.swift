import UIKit

protocol ColorCollectionViewCellDelegate {

    var selectedColor: UIColor? { get set }

    func closeColorPicker()

}

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var colorView: UIView!

    static let reuseIdentifier = "ColorCollectionViewCell"

    var delegate: ColorCollectionViewCellDelegate?
    var cellColor: UIColor?

    override var isSelected: Bool {
        didSet {
            if isSelected {
                guard let cellColor = cellColor else{
                    delegate?.closeColorPicker()
                    return
                }
                
                delegate?.selectedColor = cellColor
                delegate?.closeColorPicker()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
    }

    func updateView() {
        configureShadow()
        makeRounded()
        colorView.backgroundColor = cellColor
    }

    private func configureShadow() {
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowRadius = 2
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowOpacity = 0.5
    }

    private func makeRounded() {
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }

}
