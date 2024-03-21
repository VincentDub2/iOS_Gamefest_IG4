import SwiftUI

struct HousingView: View {
    // ViewModel instance.
    @ObservedObject var viewModel = HousingViewModel()

    // State for search bar text.
    @State private var searchQuery: String = ""
    
    // State for navigation.
    @State private var showingAddHousingView = false


    var body: some View {
        NavigationView {
            List {
                // Search bar.
                TextField("Search for housing...", text: $searchQuery, onEditingChanged: { _ in }, onCommit: {
                    viewModel.searchHousing(withKeyword: searchQuery)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                // Display each housing in a list.
                ForEach(viewModel.housings) { housing in
                    NavigationLink(destination: HousingDetailView(housing: housing)) {
                        HousingCell(housing: housing)
                    }
                }
            }
            .navigationBarTitle("Housing Offers")
            .navigationBarItems(trailing: Button(action: {
                showingAddHousingView = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddHousingView) {
                AddHousingOfferView(viewModel: viewModel)
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            viewModel.loadHousings()
        }
    }
}

// A simple view to display housing details in a list cell.
struct HousingCell: View {
    var housing: Housing
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(housing.city)
                .font(.headline)
            Text("Availability: \(housing.availability)")
                .font(.subheadline)
            if let description = housing.description {
                Text(description)
                    .font(.body)
            }
        }
        .padding()
    }
}

// Preview provider for SwiftUI previews in Xcode.
struct HousingView_Previews: PreviewProvider {
    static var previews: some View {
        HousingView()
    }
}
