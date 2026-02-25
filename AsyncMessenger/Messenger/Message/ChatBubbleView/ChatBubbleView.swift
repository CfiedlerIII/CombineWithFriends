//
//  ChatBubbleView.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/23/26.
//

import SwiftUI

struct ChatBubble<Content>: View where Content: View {
  let direction: ChatBubbleShape.Direction
  let content: () -> Content
  init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
    self.content = content
    self.direction = direction
  }

  var body: some View {
    HStack {
      if direction == .right {
        Spacer()
      }
      content()
        .clipShape(ChatBubbleShape(direction: direction))
      if direction == .left {
        Spacer()
      }
    }
    .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 4)
    .padding((direction == .right) ? .leading : .trailing, 20)

  }
}
