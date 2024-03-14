//
//  CalendarKitView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 13/03/2024.
//

import SwiftUI
import CalendarKit

struct CalendarKitView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomCalendarExampleController

    func makeUIViewController(context: Context) -> CustomCalendarExampleController {
        return CustomCalendarExampleController()
    }

    func updateUIViewController(_ uiViewController: CustomCalendarExampleController, context: Context) {
    }
}

struct CalendarKitView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarKitView()
    }
}
