//
//  CalendarViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 14/03/2024.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    static let shared = CalendarViewModel()
    
    @Published var events: [CalendarEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchEvents()
    }

    func fetchEvents() {
        isLoading = true
        PlanningService.shared.getCreneaux { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let creneaux):
                    self?.events = creneaux.map { CalendarEvent(creneau: $0) }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CalendarEvent {
    let id: Int
    let start: Date
    let end: Date
    // Autres propriétés nécessaires pour l'affichage dans le calendrier

    init(creneau: Creneau) {
        id = creneau.id
        start = Date() // Convertissez `timeStart` de `Creneau` en `Date`
        end = Date() // Convertissez `timeEnd` de `Creneau` en `Date`
        // Initialisation des autres propriétés
    }
}
