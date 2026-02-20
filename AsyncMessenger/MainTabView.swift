//
//  MainTabView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/15/26.
//

import SwiftUI

struct MainTabView: View {
  @State var isShowingAlert: Bool = false
  @State var selectedTabIndex = 0

  var body: some View {
    TabView {
      Tab("Users", systemImage: "person.3") {
        UsersView()
      }
      Tab("New User", systemImage: "person.badge.plus") {
        NewUserView()
      }
      Tab("Messenger", systemImage: "message") {
        MessengerView()
      }
    }
  }
}

#Preview {
  MainTabView()
}
