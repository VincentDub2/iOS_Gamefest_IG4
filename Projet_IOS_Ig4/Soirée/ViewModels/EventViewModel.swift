//
//  SoireeViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 19/03/2024.
//

// EventViewModel.swift
import Combine
import Foundation

class EventViewModel: ObservableObject {
    static let shared = EventViewModel()
    
    @Published var events: [Soiree] = []
    @Published var isLoading = false
    
    // Ensemble utilisé pour stocker et gérer les abonnements Combine.
    // Les abonnements stockés dans cet ensemble seront automatiquement annulés
    // lorsque l'objet EventViewModel sera détruit, évitant ainsi les fuites de mémoire.
    private var cancellables: Set<AnyCancellable> = []
    
    
    private var eventDataService = EventDataService()
    
    init() {
        loadUpcomingEvents()
    }
    // Fonction pour charger les événements
    func loadUpcomingEvents() {
        self.isLoading = true
        eventDataService.fetchUpcomingEvents()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] events in
                self?.events = events
            }
        // Stocke l'abonnement dans l'ensemble cancellables pour une gestion automatique de son cycle de vie.
            .store(in: &cancellables)
        self.isLoading = false
    }
}
