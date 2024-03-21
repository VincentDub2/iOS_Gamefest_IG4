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
    
    private var housingService = HousingService()


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
            self.housings = [Housing(id: 1, availability: 2, idUser: "1", description: "description", isOffering: true, city: "Paris", postalCode: "75000", country: "France"),
                             Housing(id: 1, availability: 2, idUser: "1", description: "description", isOffering: true, city: "Paris", postalCode: "75000", country: "France")]
            self.isLoading = false
        }
    }

    // Example function to add a housing offer.
    func addHousingOffer(availibility : String,description:String,city: String,postalCode: String,isOffering : Bool) {
        
        housingService.createHoussing(availibility: availibility, description: description, city: city, postalCode: postalCode, isOffering: isOffering)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.loadHousings()
            }
            .store(in: &cancellables);
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
