//
//  LoginView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/19/26.
//

import SwiftUI

struct LoginView: View {
  @ObservedObject var viewModel = LoginViewModel()
  @State var username: String = ""
  @State var password: String = ""

  var body: some View {
    VStack(alignment: .center) {
      Text("Welcome")
      Text("Please log in to continue")
      Spacer()
      TextField("Username", text: $username)
      SecureField("Password", text: $password)
      Spacer()
      Button("Login") {
        print("Attempting login")
        viewModel.attemptLogin(username: username, password: password)
      }
      Spacer()
    }
    .background(.white)
    .padding()
    .background(viewModel.hasAttemptedLogin ? (viewModel.isLoggedIn ? .mint : .red) : .white)
  }
}

#Preview {
  LoginView()
}
