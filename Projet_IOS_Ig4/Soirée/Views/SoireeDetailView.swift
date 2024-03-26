//
//  SoireeDetailView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 23/03/2024.
//

import Foundation
import SwiftUI

struct EventDetailView: View {
    let event: Soiree
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Event name with enhanced styling
                Text(event.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Date and Duration Section with icons
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("\(formatDate(date: event.dateEvent), formatter: itemFormatter)")
                }
                .font(.headline)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    Text("\(event.duration) minutes")
                }
                .font(.headline)
                
                // Location Section with enhanced styling
                HStack {
                    Image(systemName: "map")
                        .foregroundColor(.secondary)
                    Text("\(event.address), \(event.city), \(event.postalCode), \(event.country)")
                }
                .font(.headline)
                
                // Event Description with enhanced styling
                if let description = event.description {
                    Text("À propos: \(description)")
                        .font(.body)
                        .padding(.top, 10)
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
            .padding(.top, 90)
        }
        .navigationBarTitle(Text(event.name), displayMode: .inline)
        .background(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}


/// Format the date
/// - Parameter date: date to format (String)
/// - Returns: the formatted date
private func formatDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.timeZone = TimeZone(identifier: "Europe/Paris")
    guard let date = formatter.date(from: date) else {
        return Date()
    }
    return date
}


/// Formatter for the event date
/// - Returns: formatted date
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: Soiree(id: 1, dateEvent: "2024-03-23T18:00:00.000Z", duration: 120, address: "123 Main St", city: "Paris", postalCode: "75000", country: "France", name: "Sample Event", idManager: "1", description: "A sample event for testing purposes"))
    }
}

