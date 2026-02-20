//
//  MessagesService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/19/26.
//

import Combine
import SwiftUI

struct MessagesService {
  static func getMessages(including userId: String? = nil) -> AnyPublisher<[Message],Error> {
    let randomInt = Int.random(in: 0 ..< 4)
    if randomInt == 0 {
      print("Forcing a pretend API error.")
      return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    var urlString = "http://localhost:3000/messages"
    if let userId = userId {
      urlString += "?groupComId_like=\(userId)"
    }
    let url = URL(string: urlString)!
    return APIService.get(for: url)
  }
}
