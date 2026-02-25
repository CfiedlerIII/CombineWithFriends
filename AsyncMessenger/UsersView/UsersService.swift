//
//  UsersService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/18/26.
//

import Combine
import SwiftUI

struct UsersService {
  static func getUsers() -> AnyPublisher<[User],Error> {
    let url = URL(string: "http://localhost:3000/users")!
    return APIService.get(for: url)
  }
}

class Users: Codable, RawRepresentable {
  enum CodingKeys: String, CodingKey {
    case users
  }

  var users: [User]

  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self.users),
          let result = String(data: data, encoding: .utf8) else {
      return "{}"
    }
    return result
  }

  public init(_ users: [User]) {
    self.users = users
  }

  // Boilerplate: Implement RawRepresentable to convert self to String
  required public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode(Users.self, from: data) else {
      return nil
    }
    self.users = result.users
  }

  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    users = try container.decode([User].self, forKey: .users)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(users, forKey: .users)
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

  init(id: String, firstName: String, lastName: String, username: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.username = username
  }

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
