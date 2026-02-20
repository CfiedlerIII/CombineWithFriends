//
//  UserDetailsView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/15/26.
//

import SwiftUI

struct UserDetailsView: View {
  var userName: String
  var userId: String

  var body: some View {
    VStack {
      Text("Name: \(userName)")
      Text("ID: \(userId)")
      Spacer()
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("\(userName)")
  }
}

#Preview {
  UserDetailsView(userName: "Charles Fielder", userId: "24601")
}
