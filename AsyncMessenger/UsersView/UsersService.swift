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
    let randomInt = Int.random(in: 0 ..< 4)
    if randomInt == 0 {
      print("Forcing a pretend API error.")
      return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    let url = URL(string: "http://localhost:3000/users")!
    return APIService.get(for: url)
  }
}
