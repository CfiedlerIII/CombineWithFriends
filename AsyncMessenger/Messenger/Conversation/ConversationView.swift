//
//  ConversationView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/21/26.
//

import SwiftUI

struct ConversationView: View {
  @AppStorage("currentUser") var currentUser: User?
  @ObservedObject var viewModel: ConversationViewModel

  var body: some View {
    VStack {
      ScrollView {
        LazyVStack(spacing: 0) {
          ForEach(viewModel.messages) { message in
            ChatBubble(direction: (currentUser?.id ?? "") == message.senderId ? .right : .left) {
              Text(message.data)
                .padding()
                .background((currentUser?.id ?? "") == message.senderId ? Color.cyan : Color(red: 220/255, green: 220/255, blue: 220/255))
            }
          }
        }
      }

      HStack {
        TextField("Type a message...", text: $viewModel.newMessageText)
          .onSubmit {
            viewModel.sendMessage()
          }
        Button(action: {
          viewModel.sendMessage()
        }, label: {
          Image(systemName: "paperplane.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .foregroundColor(.mint)

        })
      }
      .padding()
      .background(Color(.systemGray6))
    }
    .navigationBarTitle(viewModel.conversation.groupNickname ?? viewModel.conversation.id)
    .task {
      viewModel.loadMessages()
    }
  }
}

#Preview {
  ConversationView(
    viewModel: ConversationViewModel(
      conversation: Conversation(
        id: "456", messages: []
      )
    )
  )
}
