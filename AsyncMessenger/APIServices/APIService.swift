//
//  APIService.swift
//  AsyncMessenger
//
//  Created by Charles Fiedler on 2/18/26.
//

import Foundation
import Combine

struct APIService {
  static func get<T: Decodable>(for url: URL) -> AnyPublisher<T,Error> {
    URLSession.shared
      .dataTaskPublisher(for: url)
      .tryMap { element -> Data in
        guard let httpResponse = element.response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else
        {
          throw URLError(.badServerResponse)
        }
        return element.data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
