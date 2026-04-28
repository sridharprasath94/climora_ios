import UIKit

// MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ForecastCell.reuseIdentifier,
            for: indexPath
        ) as? ForecastCell else {
            return UITableViewCell()
        }
        cell.configure(with: forecastDays[indexPath.row])
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        handleSearch()
    }

    func handleSearch() {
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
