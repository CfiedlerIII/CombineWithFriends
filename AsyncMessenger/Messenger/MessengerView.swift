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
      ScrollView {
        ForEach(viewModel.messages) { message in
          HStack {
            Text(message.data)
            Spacer()
          }
          .padding()
          .background(.mint)
          .clipShape(RoundedRectangle(cornerRadius: 8.0))
        }
      }
      .listStyle(.plain)
      .padding()
    }
    .task {
      viewModel.loadMessages()
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
        viewModel.loadMessages()
      }
    } message: { alert in
      Text(alert.details)
    }
  }
}

#Preview {
  MessengerView()
}
