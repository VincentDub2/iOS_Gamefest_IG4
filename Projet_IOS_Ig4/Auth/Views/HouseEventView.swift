//
//  HouseEventView.swift
//  Projet_IOS_Ig4
//
//  Created by Vincent on 28/03/2024.
//

import Foundation
import SwiftUI

struct HouseEventsView: View {
    @ObservedObject var eventViewModel = EventViewModel.shared

    var body: some View {
        VStack {
            Text("Prochaines Soirées")
                .font(.title2)
                .padding(.vertical)
                .fontWeight(.bold)

            // ScrollView horizontal pour les événements/soirées
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(eventViewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            SoireeView(event: event)
                        }
                    }
                }
                .padding([.horizontal, .bottom])
                .frame(height: 200)
            }
            Spacer()
        }
        .onAppear {
            eventViewModel.loadUpcomingEvents()
        }
    }
}

