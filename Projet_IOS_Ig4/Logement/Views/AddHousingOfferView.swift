import SwiftUI

struct AddHousingOfferView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HousingViewModel

    // State for form fields
    @State private var address: String = ""
    @State private var availability: String = ""
    @State private var description: String = ""
    @State private var city: String = "Paris"
    @State private var postalCode: String = "75000"
    @State private var isOffering: Bool = true // Default to offering a housing

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Housing Details")) {
                    TextField("Address", text: $address)
                    TextField("Availability", text: $availability)
                        .keyboardType(.numberPad)
                    TextField("Description", text: $description)
                    Toggle(isOn: $isOffering) {
                        Text("Offering")
                    }
                }
                
                Button("Submit") {
                    // Convert availability to Int
                    if let availabilityInt = Int(availability) {
                        viewModel.addHousingOffer(availibility : availability,description: description, city: city, postalCode: postalCode, isOffering: isOffering)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add Housing", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
