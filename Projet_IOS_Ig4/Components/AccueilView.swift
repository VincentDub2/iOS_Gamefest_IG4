//
//  AccueilView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import SwiftUI
import RiveRuntime


struct AccueilView: View {
    @State var isPlaying = true
    
    var button_start = RiveViewModel(fileName:"start_button")
    
    
    let chess = RiveViewModel(fileName:"avatar_pack_use_case",artboardName: "Avatar 3")
    
    
    @StateObject var chess2 = RiveViewModel(fileName: "chessactiontest",autoPlay: false)
    
    func startChess() {
        isPlaying.toggle()
        chess2.setInput("start", value: true)
    }
    
    var body: some View {
        VStack {
            Text("Festival du Jeu montpellier")
                .font(.title)
                .padding()
            VStack {
                chess2.view().aspectRatio(contentMode: .fit)
                button_start.view().aspectRatio(contentMode: .fit).onTapGesture {
                    startChess()
                }
            }
        }
    }
}

struct Accueil_Previews: PreviewProvider {
    static var previews: some View {
       AccueilView()
    }
}
