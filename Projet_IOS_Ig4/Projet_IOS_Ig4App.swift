//
//  Projet_IOS_Ig4App.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 12/03/2024.
//

import SwiftUI

@main
struct Projet_IOS_Ig4App: App {
    init(){
        _ = ForumViewModel.shared
        _ = CalendarViewModel.shared
    }
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
            ContentView()
=======
            PosteView()
>>>>>>> FestivalDetail
        }
    }
}
