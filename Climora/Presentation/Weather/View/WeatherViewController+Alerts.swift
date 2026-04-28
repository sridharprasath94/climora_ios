import UIKit

extension WeatherViewController {

    // MARK: - Error toast

    func showErrorToast(_ message: String) {
        let toast = makeToastLabel(message: message)
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            toast.heightAnchor.constraint(equalToConstant: 36),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32),
        ])
        UIView.animate(withDuration: 0.3,
                       delay: 2.5,
                       options: [],
                       animations: { toast.alpha = 0 },
                       completion: { _ in toast.removeFromSuperview() })
    }

    // MARK: - Permission alert

    func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Access Needed",
            message: "Please enable location access in Settings to fetch weather for your current location.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }

    // MARK: - Private helpers

    private func makeToastLabel(message: String) -> UILabel {
        let toast = UILabel()
        toast.text = message
        toast.font = .systemFont(ofSize: 14, weight: .medium)
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toast.textAlignment = .center
        toast.layer.cornerRadius = 18
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        return toast
    }
}
