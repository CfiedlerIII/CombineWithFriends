//
//  ConversationViewModel.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/21/26.
//

import Combine
import SwiftUI

class ConversationViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  var conversation: Conversation
  @AppStorage("currentUser") var currentUser: User?
  @Published var isLoading: Bool = true
  @Published var messages: [Message] = []
  @Published var alert: AlertMessage? = nil
  @Published var newMessageText: String = ""

  init(conversation: Conversation) {
    self.conversation = conversation
  }

  func loadMessages() {
    messages = []
    isLoading = true
    MessagesService.getMessages(inConversationWithId: conversation.id)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] result in
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
          self?.isLoading = false
          return
        }
      }, receiveValue: { [weak self] messages in
        self?.messages = messages
      })
      .store(in: &cancellables)
  }

  func sendMessage() {
    guard let user = currentUser, !newMessageText.isEmpty else {
      return
    }
    let newMessage = Message(
      convoId: conversation.id,
      senderId: user.id,
      timestamp: Date(),
      data: newMessageText
    )
    MessagesService.sendMessage(newMessage)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] result in
        switch result {
        case .failure(let error):
          print("Error: \(error)")
          self?.alert = AlertMessage(
            title: "Error",
            details: "Failed to send message"
          )
          return
        case .finished:
          self?.newMessageText = ""
          self?.messages.append(newMessage)
        }
      }, receiveValue: {}
      )
      .store(in: &cancellables)
  }
}
