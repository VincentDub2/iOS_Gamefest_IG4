//
//  FinalFormView.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 16/03/2024.
//

import Foundation

import SwiftUI

struct FinalFormView: View {
    let viewModel = ForumViewModel(forumService: ForumService())
    
    var body: some View {
        ForumView(viewModel: viewModel).padding(.bottom,100)
    }
}
