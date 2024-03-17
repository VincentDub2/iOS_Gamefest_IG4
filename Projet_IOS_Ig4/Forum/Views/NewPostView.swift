//
//  NewPostView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//

import Foundation
import SwiftUI

struct NewPostView: View {
    @ObservedObject var viewModel: ForumViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Body", text: $content)
            }
            .navigationTitle("New Post")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Post") {
                viewModel.addPost(title: title, body: content)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


