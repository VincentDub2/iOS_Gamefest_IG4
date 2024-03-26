//
//  Event.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//
// EventsListView.swift
import Foundation

import SwiftUI

struct EventsListView: View {
    @ObservedObject var viewModel = EventViewModel.shared
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(viewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            SoireeView(event: event)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Prochaines Soirées")
            .onAppear {
                self.viewModel.loadUpcomingEvents()
            }
        }
    }
}

struct SoireesListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
    }
}
