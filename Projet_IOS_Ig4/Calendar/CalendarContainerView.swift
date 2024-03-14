//
//  CalendarContainerView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 13/03/2024.
//

import Foundation
import SwiftUI

struct CalendarContainerView: View {
    var body: some View {
        CalendarView()
            .onSelectDay { dateComponents in
                // Gérez la sélection d'une date ici.
                print("Date sélectionnée:", dateComponents)
            }
    }
}


struct CalendarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainerView()
    }
}
