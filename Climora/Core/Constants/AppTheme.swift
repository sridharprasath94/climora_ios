//
//  AppTheme.swift
//  Clima
//
//  Created by Sridhar Prasath on 20.02.26.
//

import UIKit

struct AppTheme {
    let backgroundImageName: String
}

extension AppTheme {
    
    static let day = AppTheme(
        backgroundImageName: "day_image",
    )
    
    static let night = AppTheme(
        backgroundImageName: "night_image",
    )
}
