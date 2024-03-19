//
//  Date.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 19/03/2024.
//

import Foundation

struct DateUtils {
    static func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fr_FR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
