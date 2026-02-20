//
//  LoadableView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/17/26.
//

import SwiftUI

struct LoadableView: ViewModifier {
  @Binding var isLoading: Bool

  func body(content: Content) -> some View {
    ZStack {
      content.opacity(isLoading ? 0.0 : 1.0)
      ProgressView()
        .opacity(isLoading ? 1.0 : 0.0)
    }
  }
}
