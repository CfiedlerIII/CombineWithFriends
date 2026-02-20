//
//  UsersView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/13/26.
//

import SwiftUI
import Combine

struct UsersView: View {
  @ObservedObject var viewModel = UsersViewModel()

  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.users) { user in
          NavigationLink(destination:  {
            UserDetailsView(userName: "\(user.firstName) \(user.lastName)", userId: user.id)
          }) {
            HStack {
              Text(user.firstName)
              Text(user.lastName)
            }
          }
        }
      }
      .listStyle(.plain)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Users")
    }
    .opacity(viewModel.isLoading ? 0.0 : 1.0)
    .padding()
    .task {
      viewModel.loadUsers()
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
        viewModel.loadUsers()
      }
    } message: { alert in
      Text(alert.details)
    }
  }
}

#Preview {
  UsersView()
}
