//
//  AlertMessage.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/18/26.
//

import Foundation

struct AlertMessage: Identifiable {
  var id = UUID()
  var title: String
  var details: String
  var actions: [() -> Void]

  init(title: String, details: String, actions: [() -> Void] = []) {
    self.title = title
    self.details = details
    self.actions = actions
  }
}
