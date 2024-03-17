//
//  ForumViewModel.swift
//  Projet_IOS_Ig4
//
//  Created by vincent DUBUC on 15/03/2024.
//
import Foundation
import Combine

class ForumViewModel: ObservableObject {
    static let shared = ForumViewModel(forumService: ForumService())
    
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    
    let forumService: ForumService
    
    init(forumService: ForumService) {
        self.forumService = forumService
        fetchPosts()
    }
    
    func fetchPosts() {
        forumService.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancellables)
    
    }
    
    func addPost(title: String, body: String) {
        forumService.createPost(title: title, body: body)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    // Re-fetch posts after adding a new one.
                    self.fetchPosts()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func addLike(to postId: Int) {
        forumService.addLike(postId: String(postId))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    // Update the post with the new like.
                    self.fetchPosts()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func addComment(to postId: String, body: String) {
        forumService.addComment(postId: postId, body: body)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    // Update the post to show the new comment.
                    self.fetchPosts()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
