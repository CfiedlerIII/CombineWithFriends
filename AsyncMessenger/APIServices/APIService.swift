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

  static func post<T: Encodable>(dataType: T, for url: URL) -> AnyPublisher<Void,Error> {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    do {
      request.httpBody = try JSONEncoder().encode(dataType)
    }
    catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .tryMap { data, response in
        guard let httpResponse = response as? HTTPURLResponse,
                (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) else
        {
          throw URLError(.badServerResponse)
        }
        return
      }
      .eraseToAnyPublisher()
  }
}
