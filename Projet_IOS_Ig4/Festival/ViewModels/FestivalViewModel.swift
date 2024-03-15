//
//  FestivalViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire

class FestivalViewModel: ObservableObject {
    @Published var festival: FestivalModel?
    private let festivalService = FestivalService()

    func fetchFestival() {
        festivalService.fetchFestival { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let festival):
                    self.festival = festival
                case .failure(let error):
                    // Handle error
                    print("Failed to fetch festival: \(error.localizedDescription)")
                }
            }
        }
    }
}
