//
//  FestivalViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire
import SwiftUI

class FestivalViewModel: ObservableObject {
    @Published var festival: FestivalModel?
    @Published var creneauxEspaces: [CreneauEspace] = []
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

    func bindingForCurrentCapacity(creneau: Creneau, poste: Poste) -> Binding<Int> {
        Binding<Int>(
            get: { [weak self] in
                return self?.creneauxEspaces.first { $0.idCreneau == creneau.id && $0.espace.name == poste.name }?.currentCapacity ?? 0
            },
            set: { [weak self] newValue in
                // Find the index of the CreneauEspace to update its currentCapacity
                if let index = self?.creneauxEspaces.firstIndex(where: { $0.idCreneau == creneau.id && $0.espace.name == poste.name }) {
                    DispatchQueue.main.async {
                        self?.creneauxEspaces[index].currentCapacity = newValue
                    }
                }
            }
        )
    }
}
