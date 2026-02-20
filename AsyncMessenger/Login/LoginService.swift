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
    let url = URL(string: "http://localhost:3000/users?username=\(username)&password=\(password)")!
    print("LoginService: URL: \(url.absoluteString)")
    return APIService.get(for: url)
  }
}
