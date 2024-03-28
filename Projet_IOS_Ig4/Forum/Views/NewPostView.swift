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
            VStack(spacing: 0) {
                // Custom title input
                HStack {
                    Text("Title")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Enter your title here", text: $title)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.top, 5)
                // Custom content input
                HStack {
                    Text("Content")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextEditor(text: $content)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.top, 5)
                
                Spacer()
            }
            .navigationBarTitle("New Post", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Post") {
                viewModel.addPost(title: title, body: content)
                print("Post added")
                presentationMode.wrappedValue.dismiss()
            }.disabled(title.isEmpty || content.isEmpty))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(viewModel: ForumViewModel(forumService: ForumService()))
    }
}
