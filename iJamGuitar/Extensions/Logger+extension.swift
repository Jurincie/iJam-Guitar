//
//  Logger.swift
//  iJamGuitar
//
//  Created by Ron Jurincie on 12/3/23.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static let subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")

    /// All logs related to errors
    static let errors = Logger(subsystem: subsystem, category: "errors")
}
