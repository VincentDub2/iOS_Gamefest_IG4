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
    
    func loadHousings() {
        self.isLoading = true
        housingService.fetchHousing()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] posts in
                self?.housings = posts
            }
            .store(in: &cancellables)
        self.isLoading = false
    
    }
    

    // Example function to add a housing offer.
    func addHousingOffer(availibility : Int,description:String,city: String,postalCode: String,isOffering : Bool) {
        
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

    /// Searches for housing based on various optional parameters.
    ///
    /// This function allows for a flexible search of housing listings. It supports filtering based on a keyword, city, postal code, and country. All parameters are optional, and when provided, the search results will include housings that match all provided criteria. If no parameters are provided, all housings are returned.
    ///
    /// - Parameters:
    ///   - keyword: A `String` keyword to search in the housing description. Defaults to an empty string, which matches all housings.
    ///   - city: An optional `String` representing the city to filter the housings. If `nil`, city is not considered in the search.
    ///   - postalCode: An optional `String` representing the postal code to filter the housings. If `nil`, postal code is not considered in the search.
    ///   - country: An optional `String` representing the country to filter the housings. If `nil`, country is not considered in the search.
    func searchHousing(withKeyword keyword: String = "", city: String? = nil, postalCode: String? = nil, country: String? = nil) {
        if keyword.isEmpty && city == nil && postalCode == nil && country == nil {
            loadHousings() // Reload all if search is cleared
        } else {
            housings = housings.filter { housing in
                let keywordMatch = keyword.isEmpty || housing.description?.lowercased().contains(keyword.lowercased()) ?? false
                let cityMatch = city.map { housing.city.lowercased().contains($0.lowercased()) } ?? true
                let postalCodeMatch = postalCode.map { housing.postalCode.lowercased().contains($0.lowercased()) } ?? true
                let countryMatch = country.map { housing.country.lowercased().contains($0.lowercased()) } ?? true
                return keywordMatch && cityMatch && postalCodeMatch && countryMatch
            }
        }
    }
}
