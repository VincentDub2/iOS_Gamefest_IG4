//
//  HousingViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation

import Combine

class HousingViewModel: ObservableObject {
    // Publish properties to the view.
    @Published var housings: [Housing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadHousings()
    }

    // Load housing data (mocked for now, can be replaced with real network request).
    func loadHousings() {
        self.isLoading = true
        // Here you would typically make a network request to fetch the housings.
        // For demonstration purposes, we're simulating a network request with a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.housings = [Housing(address: "123 Main St", availability: 2, description: "Cozy two-bedroom near festival grounds.", isOffering: true),
                             Housing(address: "456 Side St", availability: 1, description: "Single room available for festival weekend.", isOffering: true)]
            self.isLoading = false
        }
    }

    // Example function to add a housing offer.
    func addHousingOffer(_ housing: Housing) {
        housings.append(housing)
    }

    // Example function to search for housing.
    // This function is basic and can be expanded to include more search parameters.
    func searchHousing(withKeyword keyword: String) {
        if keyword.isEmpty {
            loadHousings() // Reload all if search is cleared
        } else {
            housings = housings.filter { $0.description?.lowercased().contains(keyword.lowercased()) ?? false }
        }
    }
}
