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
    // Key: Creneau ID, Value: Poste
    @Published var userSelections: [Int: Poste] = [:]
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

    func bindingForCurrentCapacity(creneau: CreneauFestivalModel, poste: Poste) -> Binding<Int> {
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
    
    func handlePreviousAndNewSelection(forCreneau creneauId: Int, withPoste poste: Poste) {
        let newEspaceId = creneauxEspaces.first(where: { $0.espace.name == poste.name })?.idEspace
        
        // Vérifie s'il y a déjà un poste sélectionné pour ce créneau
        if let previousSelectedPoste = userSelections[creneauId],
           let previousIndex = creneauxEspaces.firstIndex(where: { $0.idCreneau == creneauId && $0.espace.name == previousSelectedPoste.name }) {
            
            // Décrémente la capacité actuelle pour le poste précédemment sélectionné
            if creneauxEspaces[previousIndex].currentCapacity > 0 {
                creneauxEspaces[previousIndex].currentCapacity -= 1
            }
        }
        
        // Met à jour la sélection
        userSelections[creneauId] = poste
    }

    func isSelected(poste: Poste, forCreneau creneauId: Int) -> Bool {
        // Check if the given poste is selected for the creneau.
        return userSelections[creneauId]?.idPoste == poste.idPoste
    }
    
    func registerVolunteer(data: IsVolunteer, completion: @escaping (Bool, Error?) -> Void) {
        festivalService.addVolunteer(data: data) { result in
            switch result {
            case .success(_):
                // Handle success
                completion(true, nil)
            case .failure(let error):
                // Handle error
                completion(false, error)
            }
        }
    }
    
    func updateSelectedCreneauxAndRegister(completion: @escaping (Bool, Error?) -> Void) {
        let group = DispatchGroup()
        var encounteredError: Error?
        
        for (creneauId, poste) in userSelections {
            if let creneauEspace = creneauxEspaces.first(where: { $0.idCreneau == creneauId && $0.espace.name == poste.name }) {
                group.enter()
                
                // Increment the current capacity
                let newCapacity = creneauEspace.currentCapacity + 1
                festivalService.updateCreneauEspace(idCreneauEspace: creneauEspace.idCreneauEspace, newCapacity: newCapacity) { [self] success in
                    if success {
                        // Add an inscription for this creneauEspace
                        let inscriptionData = InscriptionRequest(idUser: SessionManager.shared.user!.id, idCreneauEspace: creneauEspace.idCreneauEspace)
                        festivalService.addInscription(data: inscriptionData) { success in
                            if !success {
                                encounteredError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to add inscription."])
                            }
                            group.leave()
                        }
                    } else {
                        encounteredError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to update capacity."])
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = encounteredError {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }

}
