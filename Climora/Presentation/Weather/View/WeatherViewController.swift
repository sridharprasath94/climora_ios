import UIKit
import Combine

class WeatherViewController: UIViewController {

    // MARK: - Storyboard outlets

    @IBOutlet weak var backgroundOverlayView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tempDegreeLabel: UILabel!
    @IBOutlet weak var tempCelsiusLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Programmatic views

    private let conditionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let detailCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let humidityValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let feelsLikeValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let forecastCard: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let forecastLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let forecastTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorColor = AppColors.cardDivider
        table.isScrollEnabled = false
        table.rowHeight = 48
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var forecastTableHeightConstraint: NSLayoutConstraint?

    // MARK: - Dependencies

    var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    var forecastDays: [ForecastDay] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgrammaticViews()
        bindViewModel()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        viewModel.requestLocation()

        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
                self.applyColors()
                self.applySystemAppearanceOverlay()
            }
        }
    }

    // MARK: - IBActions

    @IBAction func locationButtonPressed(_ sender: UIButton) {
        searchTextField.text = ""
        viewModel.requestLocation()
    }

    // MARK: - Binding

    private func bindViewModel() {
        bindWeatherState()
        bindForecastState()
    }

    private func bindWeatherState() {
        viewModel.$weatherState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    detailCard.isHidden = true
                case .success(let weather):
                    updateWeatherUI(with: weather)
                case .permissionDenied:
                    showLocationPermissionAlert()
                case .error(let message):
                    showErrorToast(message)
                }
            }
            .store(in: &cancellables)
    }

    private func bindForecastState() {
        viewModel.$forecastState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    forecastCard.isHidden = false
                    forecastLoadingIndicator.startAnimating()
                    forecastTableView.isHidden = true
                case .success(let days):
                    forecastDays = days
                    forecastTableView.reloadData()
                    forecastTableHeightConstraint?.constant = CGFloat(days.count) * 48
                    forecastLoadingIndicator.stopAnimating()
                    forecastTableView.isHidden = false
                case .error:
                    forecastCard.isHidden = true
                    forecastLoadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Updates

    private func updateWeatherUI(with weather: Weather) {
        tempValueLabel.text = weather.temperature
        cityLabel.text = weather.cityName
        conditionTextLabel.text = weather.conditionText
        regionLabel.text = weather.region.isEmpty
            ? weather.country
            : "\(weather.region), \(weather.country)"
        humidityValueLabel.text = weather.humidity
        feelsLikeValueLabel.text = weather.feelsLike

        conditionImageView.image = UIImage(systemName: weather.conditionIconAssetName)?
            .withRenderingMode(.alwaysTemplate)

        UIView.animate(withDuration: 0.4) {
            self.backgroundView.image = UIImage(named: weather.theme.appTheme.backgroundImageName)
            self.applySystemAppearanceOverlay()
        }

        detailCard.isHidden = false
        applyColors()
    }

    private func applySystemAppearanceOverlay() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            backgroundOverlayView.alpha = 0.5
        case .light, .unspecified:
            backgroundOverlayView.alpha = 0.1
        @unknown default:
            backgroundOverlayView.alpha = 0.1
        }
    }

    private func applyColors() {
        tempValueLabel.textColor = AppColors.weatherText
        tempDegreeLabel.textColor = AppColors.weatherText
        tempCelsiusLabel.textColor = AppColors.weatherText
        cityLabel.textColor = AppColors.weatherText
        conditionImageView.tintColor = AppColors.weatherText
        conditionTextLabel.textColor = AppColors.weatherTextSecondary
        regionLabel.textColor = AppColors.weatherTextSecondary
        humidityValueLabel.textColor = AppColors.weatherText
        feelsLikeValueLabel.textColor = AppColors.weatherText
        detailCard.backgroundColor = AppColors.glassCard
        forecastCard.backgroundColor = AppColors.glassCard
        searchTextField.textColor = AppColors.weatherText
        searchTextField.backgroundColor = AppColors.searchBackground
    }

    // MARK: - Factory

    static func create(with viewModel: WeatherViewModel) -> Self {
        let storyboard = UIStoryboard(
            name: Constants.WeatherViewController.storyboardName,
            bundle: nil
        )
        guard let vc = storyboard.instantiateViewController(
            identifier: Constants.WeatherViewController.identifier
        ) as? Self else {
            fatalError("Failed to instantiate WeatherViewController from storyboard.")
        }
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - Programmatic view setup

private extension WeatherViewController {

    func setupProgrammaticViews() {
        setupConditionTextLabel()
        setupRegionLabel()
        setupForecastCard()
        setupDetailCard()
        applyColors()
        applySystemAppearanceOverlay()
    }

    func setupConditionTextLabel() {
        view.addSubview(conditionTextLabel)
        NSLayoutConstraint.activate([
            conditionTextLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),
            conditionTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            conditionTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    func setupRegionLabel() {
        view.addSubview(regionLabel)
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: conditionTextLabel.bottomAnchor, constant: 2),
            regionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            regionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    func setupDetailCard() {
        view.addSubview(detailCard)

        let humidityStack = makeDetailColumn(icon: "💧", valueLabel: humidityValueLabel, title: "Humidity")
        let feelsStack = makeDetailColumn(icon: "🌡️", valueLabel: feelsLikeValueLabel, title: "Feels like")

        let divider = UIView()
        divider.backgroundColor = AppColors.cardDivider
        divider.translatesAutoresizingMaskIntoConstraints = false

        detailCard.addSubview(humidityStack)
        detailCard.addSubview(divider)
        detailCard.addSubview(feelsStack)

        NSLayoutConstraint.activate([
            detailCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            detailCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            detailCard.bottomAnchor.constraint(equalTo: forecastCard.topAnchor, constant: -12),

            humidityStack.leadingAnchor.constraint(equalTo: detailCard.leadingAnchor, constant: 16),
            humidityStack.centerYAnchor.constraint(equalTo: detailCard.centerYAnchor),
            humidityStack.trailingAnchor.constraint(equalTo: divider.leadingAnchor, constant: -8),

            divider.centerXAnchor.constraint(equalTo: detailCard.centerXAnchor),
            divider.centerYAnchor.constraint(equalTo: detailCard.centerYAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 48),

            feelsStack.leadingAnchor.constraint(equalTo: divider.trailingAnchor, constant: 8),
            feelsStack.centerYAnchor.constraint(equalTo: detailCard.centerYAnchor),
            feelsStack.trailingAnchor.constraint(equalTo: detailCard.trailingAnchor, constant: -16),

            humidityStack.widthAnchor.constraint(equalTo: feelsStack.widthAnchor),
            detailCard.topAnchor.constraint(equalTo: humidityStack.topAnchor, constant: -20),
            detailCard.bottomAnchor.constraint(equalTo: humidityStack.bottomAnchor, constant: 20),
        ])
    }

    func makeDetailColumn(icon: String, valueLabel: UILabel, title: String) -> UIStackView {
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = AppColors.weatherTextSecondary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [iconLabel, valueLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    func setupForecastCard() {
        view.addSubview(forecastCard)

        forecastCard.addSubview(forecastLoadingIndicator)
        forecastCard.addSubview(forecastTableView)

        forecastTableView.dataSource = self
        forecastTableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.reuseIdentifier)

        let tableHeight = forecastTableView.heightAnchor.constraint(equalToConstant: 0)
        forecastTableHeightConstraint = tableHeight

        NSLayoutConstraint.activate([
            forecastCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            forecastCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            forecastCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            forecastLoadingIndicator.centerXAnchor.constraint(equalTo: forecastCard.centerXAnchor),
            forecastLoadingIndicator.topAnchor.constraint(equalTo: forecastCard.topAnchor, constant: 16),
            forecastLoadingIndicator.bottomAnchor.constraint(equalTo: forecastCard.bottomAnchor, constant: -16),

            forecastTableView.topAnchor.constraint(equalTo: forecastCard.topAnchor),
            forecastTableView.leadingAnchor.constraint(equalTo: forecastCard.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: forecastCard.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: forecastCard.bottomAnchor),
            tableHeight,
        ])
    }
}
