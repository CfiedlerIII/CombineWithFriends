//
//  UsersViewModel.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/13/26.
//

import Combine
import SwiftUI

class UsersViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  @Published var isLoading: Bool = false
  @Published var users: [User] = []
  @Published var alert: AlertMessage? = nil

  func loadUsers() {
    users = []
    isLoading = true
    UsersService.getUsers()
      .delay(for: 1.5, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
      .sink { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("Error: \(error)")
          self?.alert = AlertMessage(
            title: "Error",
            details: "Failed to load users"
          )
          self?.isLoading = false
          return
          
        case .finished:
          print("Finished fetching users")
          self?.isLoading = false
          return
        }
      } receiveValue: { [weak self] (users) in
        print("Setting fetched users")
        self?.users = users
      }
      .store(in: &cancellables)
  }
}
