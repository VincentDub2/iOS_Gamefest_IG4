//
//  testRive.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import RiveRuntime
import SwiftUI

struct AnimationView: View {
    var body: some View {
        RiveViewModel(fileName: "walking_working").view()
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
