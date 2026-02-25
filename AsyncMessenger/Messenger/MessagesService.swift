//
//  MessagesService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/19/26.
//

import Combine
import SwiftUI

struct MessagesService {
  static func getConversations(including userId: String? = nil) -> AnyPublisher<[Conversation],Error> {
    var urlString = "http://localhost:3000/conversations"
    if let userId = userId {
      urlString += "?id_like=\(userId)"
    }
    print("Conversation URL: \(urlString)")
    let url = URL(string: urlString)!
    return APIService.get(for: url)
  }

  static func getMessages(inConversationWithId conversationId: String) -> AnyPublisher<[Message],Error> {
    let urlString = "http://localhost:3000/messages?convoId=\(conversationId)"
    print("Conversation URL: \(urlString)")
    let url = URL(string: urlString)!
    return APIService.get(for: url)
  }

  static func sendMessage(_ message: Message) -> AnyPublisher<Void,Error> {
    let urlString = "http://localhost:3000/messages"
    print("Message URL: \(urlString)")
    let url = URL(string: urlString)!
    return APIService.post(dataType: message, for: url)
  }
}

class Conversation: Codable, Identifiable {
  var id: String
  var groupNickname: String?
  var messages: [Message]

  init(id: String = UUID().uuidString, groupNickname: String? = nil, messages: [Message]) {
    self.id = id
    self.groupNickname = groupNickname
    self.messages = messages
  }
}

class Message: Codable, Identifiable {
  var id: String
  var convoId: String
  var senderId: String
  var timestamp: Date?
  var data: String

  enum CodingKeys: String, CodingKey {
    case id
    case convoId
    case senderId
    case timestamp
    case data
  }

  init(convoId: String, senderId: String, timestamp: Date? = nil, data: String) {
    self.id = UUID().uuidString
    self.convoId = convoId
    self.senderId = senderId
    self.timestamp = timestamp
    self.data = data
  }

  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.convoId = try container.decode(String.self, forKey: .convoId)
    self.senderId = try container.decode(String.self, forKey: .senderId)
    if let timestampString = try container.decodeIfPresent(String.self, forKey: .timestamp) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      self.timestamp = dateFormatter.date(from: timestampString)
    }
    self.data = try container.decode(String.self, forKey: .data)
  }

  func decode(_ decoder: inout Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.convoId = try container.decode(String.self, forKey: .convoId)
    self.senderId = try container.decode(String.self, forKey: .senderId)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let timestampString = try container.decodeIfPresent(String.self, forKey: .timestamp) {
      self.timestamp = dateFormatter.date(from: timestampString)
    }
    self.data = try container.decode(String.self, forKey: .data)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(convoId, forKey: .convoId)
    try container.encode(senderId, forKey: .senderId)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let timestampString = dateFormatter.string(from: timestamp ?? Date())
    try container.encode(timestampString, forKey: .timestamp)
    try container.encode(data, forKey: .data)
  }
}
