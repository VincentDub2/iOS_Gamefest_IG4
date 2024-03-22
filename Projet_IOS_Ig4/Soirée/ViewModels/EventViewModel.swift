//
//  SoireeViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 19/03/2024.
//

// EventViewModel.swift

import Foundation

class EventViewModel: ObservableObject {
    @Published var events: [Soiree] = []
    private var eventDataService = EventDataService()
    
    // Fonction pour charger les événements
    func loadUpcomingEvents() {
        eventDataService.fetchUpcomingEvents { [weak self] fetchedEvents in
            self?.events = fetchedEvents
        }
    }
}
