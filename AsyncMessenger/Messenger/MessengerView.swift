//
//  MessengerView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/15/26.
//

import Combine
import SwiftUI

struct MessengerView: View {
  @ObservedObject var viewModel = MessengerViewModel()

  var body: some View {
    ZStack {
      VStack {
        Text("Messages")
        NavigationStack {
          List {
            ForEach(viewModel.conversations) { convo in
              NavigationLink(destination:  {
                ConversationView(
                  viewModel: .init(
                    conversation: convo
                  )
                )
              }) {
                Text(convo.groupNickname ?? convo.id)
              }
            }
          }
          .listStyle(.plain)
          .padding()
        }
      }
    }
    .task {
      viewModel.loadConversations()
    }
    .modifier(LoadableView(isLoading: $viewModel.isLoading))
    .alert(
      Text(viewModel.alert?.title ?? "Error"),
      isPresented: Binding<Bool>(
        get: { viewModel.alert != nil },
        set: { newValue in
          if !newValue {
            viewModel.alert = nil // Dismiss the alert
          }
        }
      ),
      presenting: viewModel.alert
    ) { _ in
      Button("OK", role: .cancel) {
        viewModel.alert = nil
      }
      Button("Retry") {
        viewModel.alert = nil
        viewModel.loadConversations()
      }
    } message: { alert in
      Text(alert.details)
    }
  }
}

#Preview {
  MessengerView()
}
