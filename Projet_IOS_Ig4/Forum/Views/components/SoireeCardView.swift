//
//  SoireeCardView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 19/03/2024.
//

import Foundation
import SwiftUI

struct SoireeCardView: View {
    var soiree: Soiree
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(soiree.name)
                        .font(.title)
                        .foregroundColor(.primary)
                    Text(soiree.dateEvent.ISO8601Format())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
