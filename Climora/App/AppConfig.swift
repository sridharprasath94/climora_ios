//
//  AppConfig.swift
//  Clima
//
//  Created by Sridhar Prasath on 19.02.26.
//

import Foundation

enum AppConfig {
    
    enum Weather {
        
        static var apiKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String,
                  !key.isEmpty else {
                fatalError("Missing or empty WEATHER_API_KEY in Info.plist")
            }
            return key
        }
        
        static var baseURL: URL {
            guard let urlString = Bundle.main.object(forInfoDictionaryKey: "WEATHER_BASE_URL") as? String,
                  let url = URL(string: urlString) else {
                fatalError("Invalid or missing WEATHER_BASE_URL in Info.plist")
            }
            return url
        }
    }
}
