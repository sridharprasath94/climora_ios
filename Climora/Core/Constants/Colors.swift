import UIKit

enum AppColors {
    /// Primary text on photo background — dark in light mode, white in dark mode.
    static let weatherText = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? .white
            : UIColor(white: 0.1, alpha: 1)
    }

    /// Secondary / subdued text.
    static let weatherTextSecondary = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.8)
            : UIColor(white: 0.2, alpha: 0.7)
    }

    /// Frosted-glass card surface.
    static let glassCard = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 0, alpha: 0.4)
            : UIColor(white: 1, alpha: 0.75)
    }

    /// Search field background.
    static let searchBackground = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 0, alpha: 0.4)
            : UIColor(white: 1, alpha: 0.75)
    }

    /// Thin divider between card columns.
    static let cardDivider = UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 1, alpha: 0.25)
            : UIColor(white: 0, alpha: 0.15)
    }
}
