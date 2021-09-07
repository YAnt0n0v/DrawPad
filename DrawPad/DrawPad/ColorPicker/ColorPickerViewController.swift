import UIKit

protocol DrawPadColorPickerViewControllerDelegate {

    func update(with color: UIColor?)

}

class ColorPickerViewController: UIViewController {

    @IBOutlet private weak var colorsPickerView: UIView!

    private let colors = ColorsCollection()

    var selectedColor: UIColor? = .black
    var delegate: DrawPadColorPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        configureView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        delegate?.update(with: selectedColor)
    }

    private func configureView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeColorPicker(_:)))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)

        colorsPickerView.layer.cornerRadius = 20
        configureShadow()
    }

    private func configureShadow() {
        colorsPickerView.layer.shadowColor = UIColor.black.cgColor
        colorsPickerView.layer.shadowRadius = 5
        colorsPickerView.layer.shadowOffset = .zero
        colorsPickerView.layer.shadowOpacity = 0.5
    }

    @objc
    private func closeColorPicker(_ gestureRecognizer: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

}

extension ColorPickerViewController: ColorCollectionViewCellDelegate {

    func closeColorPicker() {
        dismiss(animated: true, completion: nil)
    }

}

extension ColorPickerViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.cellColor = colors[indexPath.row]
        cell.delegate = self
        cell.updateView()

        return cell
    }

}

extension ColorPickerViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view else {
            return true
        }

        if touchView.isDescendant(of: colorsPickerView) {
            return false
        }

        return true
    }

}

extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48.0, height: 48.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.6
    }

}
