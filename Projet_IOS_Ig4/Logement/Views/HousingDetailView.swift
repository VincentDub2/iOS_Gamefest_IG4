//
//  HousingDetailView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation
import SwiftUI

struct HousingDetailView: View {
    var housing: Housing

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(housing.city)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Availability: \(housing.availability)")
                .font(.headline)
            
            if let description = housing.description {
                Text(description)
                    .font(.body)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle(Text("Housing Details"), displayMode: .inline)
    }
}
