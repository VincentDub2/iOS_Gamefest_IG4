//
//  CommentInputView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 16/03/2024.
//

import Foundation
import SwiftUI
import RiveRuntime
struct CommentInputView: View {
    @Binding var newComment: String
    var isPlaying: Bool = false
    let placeholder: String
    var onCommit: () -> Void = {}
    var modelRive = RiveViewModel(fileName: "new_file",autoPlay: false)
    
    func handleCommit() {
        print("HandleCommit : comment added")
        onCommit()
        newComment = ""
        modelRive.play()
    }
    

    var body: some View {
        HStack {
            TextField(placeholder, text: $newComment, onCommit:handleCommit)
                .padding(.leading, 8)
            modelRive.view()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    handleCommit()
                }
            
            
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(newComment: .constant(""), placeholder: "Ajouter un commentaire", onCommit: {
                
        })
    }
}
