//
//  EventView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//

import Foundation
import SwiftUI
import Combine
import UIKit

struct SoireeView : View {
    let event: Soiree
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.title2) // Makes the event name stand out more
                .fontWeight(.bold) // Adds emphasis to the event name
                .foregroundColor(.primary) // Ensures high readability
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.secondary) // Uses system image for date
                Text("\(formatDate(date : event.dateEvent), formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "map")
                    .foregroundColor(.secondary) // Uses system image for location
                Text(event.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white) // Changes background to white for a cleaner look
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Softens the shadow for a subtle depth effect
        .overlay(
            // Optional: Add a tag or indicator for special events
            VStack {
                if event.postalCode == "34165" {
                    Text("SPECIAL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(8)
                }
                Spacer()
            },
            alignment: .topTrailing // Places the special tag at the top-right corner
        )
    }
}



private func formatDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    guard let date = formatter.date(from: date) else {
        return Date()
    }
    return date
}

private let itemFormatter: DateFormatter = {
    
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
