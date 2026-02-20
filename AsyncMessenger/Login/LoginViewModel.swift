//
//  LoginViewModel.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/19/26.
//

import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
  private var cancellables = Set<AnyCancellable>()
  @AppStorage("currentUser") var currentUser: User? = nil
  @Published var isLoading: Bool = false
  @Published var isLoggedIn: Bool = false
  @Published var hasAttemptedLogin: Bool = false
  @Published var alert: AlertMessage? = nil

  func attemptLogin(username: String, password: String) {
    LoginService.login(
      username: username.lowercased(),
      password: password.lowercased()
    )
    .delay(for: 1.5, scheduler: RunLoop.main)
    .receive(on: RunLoop.main)
    .sink { [weak self] (result) in
      switch result {
      case .failure(let error):
        print("LoginVM: Error: \(error)")
        self?.hasAttemptedLogin = true
        self?.isLoggedIn = false
        self?.alert = AlertMessage(
          title: "Error",
          details: "Failed to login"
        )
        self?.isLoading = false
        return

      case .finished:
        print("LoginVM: Positive login response")
        self?.hasAttemptedLogin = true
        self?.isLoading = false
        return
      }
    } receiveValue: { [weak self] (loginUsers) in
      print("LoginVM: Validating login response")
      self?.isLoggedIn = loginUsers.count == 1
      print(loginUsers.count == 1 ? "LoginVM: Logging In!" : "LoginVM: Failed to log in")
      self?.currentUser = loginUsers.first
    }
    .store(in: &cancellables)
  }
}
