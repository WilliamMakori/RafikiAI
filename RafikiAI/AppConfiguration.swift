//
//  AppConfiguration.swift
//  RafikiAI
//
//  Created by Makori Chacha on 2025-11-19.
//

import Foundation

enum AppConfiguration {
    static var openaiAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["OpenAIAPIKey"] as? String,
              !key.isEmpty else {
            fatalError("OpenAI API key is not configured. Please add it to Secrets.xcconfig")
        }
        return key
    }
}
