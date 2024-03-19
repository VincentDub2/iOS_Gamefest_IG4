//
//  AnimateAvatar.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 17/03/2024.
//

import Foundation
import SwiftUI
import RiveRuntime

struct AnimateAvatar: View {
    var avatar: RiveViewModel
    var zoom: CGFloat = 1
    
    init(number : Int) {
        switch number {
        case 1:
            self.avatar = RiveViewModel(fileName: "avatar_pack_use_case", artboardName: "Avatar 1")
        case 2:
            self.avatar = RiveViewModel(fileName: "avatar_pack_use_case", artboardName: "Avatar 2")
        case 3:
            self.avatar = RiveViewModel(fileName: "avatar_pack_use_case", artboardName: "Avatar 3")
        case 4:
            self.avatar = RiveViewModel(fileName: "walking_working")
            self.zoom=1.5
        case 5:
            self.avatar = RiveViewModel(fileName: "game_charecter")
            self.zoom=1.5
        case 6:
            self.avatar = RiveViewModel(fileName: "404_cat",autoPlay: true)
        case 7:
            self.avatar = RiveViewModel(fileName: "hey_ho_let's_go!")
            self.zoom=1.5
        case 8:
            self.avatar = RiveViewModel(fileName: "sith_de_mayo")
        case 9:
            self.avatar = RiveViewModel(fileName: "skin_demo_2")
            self.zoom=1.3
        case 10:
            self.avatar = RiveViewModel(fileName: "noonnap")
        default:
            self.avatar = RiveViewModel(fileName: "avatar_pack_use_case", artboardName: "Avatar 2")
        }
        
    }
    var body: some View {
        avatar.view()
            .frame(width: 50, height: 50)
            .scaledToFit()
            .scaleEffect(zoom)
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
    }
}


struct AnimateAvatar_Previews: PreviewProvider {
    static var previews: some View {
        AnimateAvatar(number: 10)
    }
}
