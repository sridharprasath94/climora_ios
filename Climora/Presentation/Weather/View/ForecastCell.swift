import UIKit

final class ForecastCell: UITableViewCell {
    static let reuseIdentifier = "ForecastCell"

    // MARK: - Subviews

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let conditionIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let tempRangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
        registerTraitObserver()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configure

    func configure(with day: ForecastDay) {
        dayLabel.text = day.dayLabel
        conditionIcon.image = UIImage(systemName: day.conditionIconName)?
            .withRenderingMode(.alwaysTemplate)
        tempRangeLabel.text = "\(Int(day.maxTemp))° / \(Int(day.minTemp))°"
        applyColors()
    }

    private func registerTraitObserver() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
                self.applyColors()
            }
        }
    }

    // MARK: - Private

    private func applyColors() {
        dayLabel.textColor = AppColors.weatherText
        conditionIcon.tintColor = AppColors.weatherText
        tempRangeLabel.textColor = AppColors.weatherText
    }

    private func setupLayout() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(conditionIcon)
        contentView.addSubview(tempRangeLabel)

        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            conditionIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            conditionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            conditionIcon.widthAnchor.constraint(equalToConstant: 26),
            conditionIcon.heightAnchor.constraint(equalToConstant: 26),

            tempRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempRangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
        ])
    }
}
