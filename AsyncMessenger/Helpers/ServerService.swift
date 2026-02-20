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
