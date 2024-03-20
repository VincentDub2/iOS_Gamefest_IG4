//
//  HousingView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 20/03/2024.
//

import Foundation
import SwiftUI

struct HousingView: View {
    @ObservedObject var viewModel: HousingViewModel
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $searchText)
                    .padding()
                    .onChange(of: searchText) { newValue in
                        viewModel.searchHousing(withKeyword: newValue)
                    }

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(viewModel.housings) { housing in
                        HousingCell(housing: housing)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Housing Offers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Trigger adding a new housing offer
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct HousingCell: View {
    let housing: Housing

    var body: some View {
        VStack(alignment: .leading) {
            Text(housing.address)
                .font(.headline)
            Text("Availability: \(housing.availability)")
                .font(.subheadline)
            if let description = housing.description {
                Text(description)
                    .font(.body)
            }
        }
    }
}

// A simple preview for SwiftUI Canvas
struct HousingView_Previews: PreviewProvider {
    static var previews: some View {
        HousingView(viewModel: HousingViewModel())
    }
}
