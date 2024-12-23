//
//  Logger.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

class Logger {
    
    enum LogLevel: String {
        case debug = "DEBUG"
        case error = "ERROR"
        case info = "INFO"
        case warning = "WARNING"
    }
    
    static let shared = Logger()
    
    private init() {}
    
    func debug(_ message: String) {
        log(message, level: .debug)
    }
    
    func error(_ message: String) {
        log(message, level: .error)
    }
    
    func info(_ message: String) {
        log(message, level: .info)
    }
    
    func warning(_ message: String) {
        log(message, level: .warning)
    }
    
    private func log(_ message: String, level: LogLevel) {
        let timestamp = Date().logFormatted()
        let logMessage = "[\(level.rawValue)] \(timestamp): \(message)"
        print(logMessage)
    }
}

extension Date {
    func logFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
