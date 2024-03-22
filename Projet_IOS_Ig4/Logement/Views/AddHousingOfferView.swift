import SwiftUI

struct AddHousingOfferView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HousingViewModel

    // State for form fields
    @State private var availability: String = ""
    @State private var description: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var isOffering: Bool = true // Default to offering housing
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ajouter un logement")) {
                    TextField("Nombre de personne", text: $availability)
                        .keyboardType(.numberPad)
                    TextField("Description de ce vous chercher ou proposé", text: $description)
                    Toggle(isOn: $isOffering) {
                        Text(isOffering ? "Proposition" : "Recherche")
                    }
                }
                
                Section(header: Text("Localisation")) {
                    TextField("Ville", text: $city)
                    TextField("Code Postal", text: $postalCode)
                        .keyboardType(.numberPad)
                }
                
                Button("Submit") {
                    // Validate input before submitting
                    print(availability)
                    guard let availabilityInt = Int(availability), !description.isEmpty, !city.isEmpty, !postalCode.isEmpty else {
                        alertMessage = "Please fill all the fields correctly."
                        showAlert = true
                        return
                    }
                    
                    viewModel.addHousingOffer(availibility: availabilityInt, description: description, city: city, postalCode: postalCode, isOffering: isOffering)
                    presentationMode.wrappedValue.dismiss()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarTitle("Add Housing", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddHousingOfferView_Previews: PreviewProvider {
    static var previews: some View {
        AddHousingOfferView(viewModel: HousingViewModel())
    }
}
