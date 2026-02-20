//
//  ViewController.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import UIKit
import Combine

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var backgroundOverlayView: UIView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tempDegreeLabel: UILabel!
    @IBOutlet weak var tempCelsiusLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        searchTextField.text = ""
        viewModel.requestLocation()
    }
    var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        viewModel.requestLocation()
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection) in
                self.applySystemAppearanceOverlay()
            }
        }
    }
    
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle:
                    break
                    
                case .loading:
                    print("Loading weather...")
                    
                case .success(let weather):
                    self.updateUI(with: weather)
                    
                case .permissionDenied:
                    self.showLocationPermissionAlert()
                    
                case .error(let message):
                    print("Error:", message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with weather: Weather) {
        tempValueLabel.text = weather.temperature
        cityLabel.text = weather.cityName
        conditionImageView.image = UIImage(systemName: weather.conditionIconAssetName)
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.image = UIImage(named: weather.theme.appTheme.backgroundImageName)
            self.applySystemAppearanceOverlay()
        }
    }
    
    private func applySystemAppearanceOverlay() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            backgroundOverlayView.alpha = 0.35
        case .light, .unspecified:
            backgroundOverlayView.alpha = 0.1
        @unknown default:
            backgroundOverlayView.alpha = 0.1
        }
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Access Needed",
            message: "Please enable location access in Settings to fetch weather for your current location.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        present(alert, animated: true)
    }
}


extension WeatherViewController {
    static func create(with viewModel: WeatherViewModel) -> Self {
        let storyboard = UIStoryboard(name:  K.WeatherViewController.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: K.WeatherViewController.identifier) as! Self
        vc.viewModel = viewModel
        return vc
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        handleSearch()
    }
    
    
    private func handleSearch() {
        guard let city = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !city.isEmpty else {
            searchTextField.text = ""
            searchTextField.placeholder = "Please enter a city"
            searchTextField.becomeFirstResponder()
            return
        }
        
        searchTextField.resignFirstResponder()
        viewModel.fetchCurrentWeather(for: city)
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSearch()
        return true
    }
}
