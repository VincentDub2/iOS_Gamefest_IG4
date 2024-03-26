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
    
    static let shared = HousingViewModel()
    
    private var housingService = HousingService()


    private var cancellables: Set<AnyCancellable> = []

    init() {
        loadHousings()
    }
    
    /// Load the housing offers from the database.
    /// - Returns: Void
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
    

    /// Adds a new housing offer to the database.
    /// - Parameters:
    ///  - availibility: An `Int` representing the number of available rooms in the housing.
    ///  - description: A `String` description of the housing.
    ///  - city: A `String` representing the city where the housing is located.
    ///  - postalCode: A `String` representing the postal code of the housing.
    ///  - isOffering: A `Bool` indicating whether the housing is being offered or requested.
    ///  - Returns: Void
    func addHousingOffer(availability: Int, description: String, city: String, postalCode: String, isOffering: Bool, completion: @escaping (Bool) -> Void) {
        // Start your loading process
        housingService.createHousing(availability: availability, description: description, city: city, postalCode: postalCode, isOffering: isOffering)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    // If the operation finishes successfully, call the completion handler with true
                    completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    // In case of an error, call the completion handler with false
                    completion(false)
                }
                self.isLoading = false
            }, receiveValue: { _ in
                self.loadHousings()
            })
            .store(in: &cancellables)
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
    
    /// Deletes a housing offer from the database.
    /// - Parameter housing: The id of the housing to delete.
    /// - Returns: Void
    func deleteHousing(_ id: Int, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        housingService.deleteHousing(id: id)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                   completion(true)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
                self.isLoading = false
            } receiveValue: { _ in
                self.loadHousings()
            }
            .store(in: &cancellables)
    }
}
