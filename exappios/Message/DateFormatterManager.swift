//
//  DateFormatterManager.swift
//  exappios
//
//  Created by Tami on 11.09.2024.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}

    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var fullDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private lazy var formatDateWithDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func dayFormatterInstance() -> DateFormatter {
        return formatDateWithDay
    }
    
    func timeFormatterInstance() -> DateFormatter {
        return timeFormatter
    }

    func dateFormatterInstance() -> DateFormatter {
        return dateFormatter
    }

    func fullDateTimeFormatterInstance() -> DateFormatter {
        return fullDateTimeFormatter
    }
}

