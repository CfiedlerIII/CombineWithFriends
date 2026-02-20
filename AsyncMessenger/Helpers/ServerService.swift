//
//  ServerService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/13/26.
//

import Combine
import SwiftUI

actor ServerService {
  public static let shared = ServerService()
  private let hostPath = "http://localhost:3000"
  private var cancellable: AnyCancellable?

  private init() {}
  
  func fetchUsers() async throws -> [User] {
    let url = URL(string: "\(hostPath)/users")!
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode([User].self, from: data)
  }

  func fetchMessages(completion: @escaping (Result<[Message],URLError>) -> Void) async {
    let url = URL(string: "\(hostPath)/messages")!
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .delay(for: 1.5, scheduler: RunLoop.main)
      .tryMap { urlReturn -> Data in
        let randomInt = Int.random(in: 0 ..< 2)
        guard randomInt == 1, let httpResponse = urlReturn.response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
          completion(.failure(URLError(.badServerResponse)))
          return Data()
        }
        return urlReturn.data
      }
      .decode(type: [Message].self, decoder: JSONDecoder())
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            print("Received completion: Finished.")

          case .failure(let error):
            print("Received completion: Error: \(error.localizedDescription)")
          }
        },
        receiveValue: { messages in
          guard let firstMessage = messages.first else { return }
          print("Received ID: \(firstMessage.id), data: \(firstMessage.data)")
          completion(.success(messages))
        }
      )
  }
}

class User: Codable, Identifiable, RawRepresentable {
  enum CodingKeys: String, CodingKey {
    case id
    case firstName
    case lastName
    case username
  }

  var id: String
  var firstName: String
  var lastName: String
  var username: String

  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
    username = try container.decode(String.self, forKey: .username)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(firstName, forKey: .firstName)
    try container.encode(lastName, forKey: .lastName)
    try container.encode(username, forKey: .username)
  }

  // Boilerplate: Implement RawRepresentable to convert self to String
  required public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode(User.self, from: data) else {
      return nil
    }
    self.id = result.id
    self.firstName = result.firstName
    self.lastName = result.lastName
    self.username = result.username
  }

  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8) else {
      return "{}"
    }
    return result
  }
}

class Message: Codable, Identifiable {
  var id: String
  var groupComId: String
  var senderId: String
  var data: String
}
