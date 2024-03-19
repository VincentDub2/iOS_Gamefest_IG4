//
//  Projet_IOS_Ig4App.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI

@main
struct Projet_IOS_Ig4App: App {
    var body: some Scene {
        WindowGroup {
            SignupFestivalView(festivalName: "Sample Festival", startDate: "01/01/2024", endDate: "03/01/2024")
        }
    }
}
