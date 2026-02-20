//
//  LoginService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/19/26.
//

import Combine
import SwiftUI

struct LoginService {
  static func login(username: String, password: String) -> AnyPublisher<[User],Error> {
    let randomInt = Int.random(in: 0 ..< 4)
    if randomInt == 0 {
      print("LoginService: Forcing a pretend API error.")
      return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    let url = URL(string: "http://localhost:3000/users?username=\(username)&password=\(password)")!
    print("LoginService: URL: \(url.absoluteString)")
    return APIService.get(for: url)
  }
}
