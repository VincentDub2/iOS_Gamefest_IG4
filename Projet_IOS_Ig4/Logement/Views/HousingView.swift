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
                TextField("Rechercher un logement...", text: $searchQuery, onEditingChanged: { _ in }, onCommit: {
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
            .navigationBarTitle("Offres de logement")
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


// Preview provider for SwiftUI previews in Xcode.
struct HousingView_Previews: PreviewProvider {
    static var previews: some View {
        HousingView()
    }
}
