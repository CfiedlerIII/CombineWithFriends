//
//  MessengerViewModel.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/17/26.
//

import Combine
import SwiftUI

class MessengerViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  @AppStorage("currentUser") var currentUser: User?
  @Published var isLoading: Bool = true
  @Published var messages: [Message] = []
  @Published var alert: AlertMessage? = nil

  func loadMessages() {
    messages = []
    isLoading = true
    MessagesService.getMessages(including: currentUser?.id)
      .delay(for: 1.5, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
      .sink { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("Error: \(error)")
          self?.alert = AlertMessage(
            title: "Error",
            details: "Failed to load messages"
          )
          self?.isLoading = false
          return

        case .finished:
          print("Finished fetching messages")
          self?.isLoading = false
          return
        }
      } receiveValue: { [weak self] (messages) in
        print("Setting fetched messages")
        self?.messages = messages
      }
      .store(in: &cancellables)
  }
}
