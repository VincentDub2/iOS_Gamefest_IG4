//
//  PosteViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by Bastian on 15/03/2024.
//

import Foundation
import Alamofire


    
class PosteViewModel: ObservableObject {
    @Published var poste: PosteModel?
    private let posteService = PosteService()
    
    

    func fetchPoste(postId: String) { // Acceptez postId comme paramètre
        posteService.fetchPoste(postId: postId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let poste):
                    self.poste = poste
                case .failure(let error):
                    print("Failed to fetch poste: \(error.localizedDescription)")
                }
            }
        }
    }
}
