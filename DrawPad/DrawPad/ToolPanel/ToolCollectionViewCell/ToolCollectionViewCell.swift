import UIKit

protocol ToolPanelDelegate {

    func toolUpdated(to tool: Tool.ToolType)

}

class ToolCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    private var toolType: Tool.ToolType = .brush

    static let reuseIdentifier = "ToolCollectionViewCell"
    var delegate: ToolPanelDelegate?

    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconImageView.tintColor = .black
                titleLabel.textColor = .black
                delegate?.toolUpdated(to: toolType)
            }
            else {
                iconImageView.tintColor = .white
                titleLabel.textColor = .white
            }
        }
    }

    func configure(with tool: Tool) {
        iconImageView.image = tool.icon
        titleLabel.text = tool.title
        toolType = tool.type
    }

}
