//
//  AsyncMessengerApp.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/13/26.
//

import SwiftUI

@main
struct AsyncMessengerApp: App {
  @AppStorage("currentUser") var currentUser: User? = nil

  var body: some Scene {
    WindowGroup {
      if currentUser == nil {
        LoginView()
      } else {
        MainTabView()
      }
    }
  }
}
