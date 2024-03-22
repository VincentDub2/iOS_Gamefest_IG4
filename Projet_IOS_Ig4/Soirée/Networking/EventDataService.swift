//
//  EventDataService.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 22/03/2024.
//

import Foundation
// EventDataService.swift


class EventDataService {
    // Simulons un appel réseau ou une récupération de données depuis une base de données locale pour cet exemple.
    // Dans une application réelle, cette partie intégrerait un appel à une API ou une base de données locale comme CoreData ou Realm.
    
    func fetchUpcomingEvents(completion: @escaping ([Soiree]) -> Void) {
        // Simuler un délai réseau
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            let mockEvents = [
                Soiree(id: 1, dateEvent: Date(), duration: 120, address: "123 Main St", city: "Paris", postalCode: "75000", country: "France", name: "Soirée Jazz", idManager: "manager1", description: "Une belle soirée de jazz."),
                Soiree(id: 2, dateEvent: Date(), duration: 120, address: "123 Main St", city: "Paris", postalCode: "75000", country: "France", name: "Soirée Jazz", idManager: "manager1", description: "Une belle soirée de jazz."),
                Soiree(id: 3, dateEvent: Date(), duration: 120, address: "123 Main St", city: "Paris", postalCode: "75000", country: "France", name: "Soirée Jazz", idManager: "manager1", description: "Une belle soirée de jazz."),
                Soiree(id: 4, dateEvent: Date(), duration: 120, address: "123 Main St", city: "Paris", postalCode: "75000", country: "France", name: "Soirée Jazz", idManager: "manager1", description: "Une belle soirée de jazz."),
                // Ajouter plus d'événements mock ici
            ]
            DispatchQueue.main.async {
                completion(mockEvents)
            }
        }
    }
}
