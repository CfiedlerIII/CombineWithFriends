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
    var urlString = "http://localhost:3000/messages"
    if let userId = userId {
      urlString += "?groupComId_like=\(userId)"
    }
    let url = URL(string: urlString)!
    return APIService.get(for: url)
  }
}

class Message: Codable, Identifiable {
  var id: String
  var groupComId: String
  var senderId: String
  var data: String
}
