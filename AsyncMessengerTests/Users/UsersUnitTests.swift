//
//  UsersUnitTests.swift
//  AsyncMessengerTests
//
//  Created by Charles Fiedler on 2/19/26.
//

import Foundation
import Testing

struct UsersUnitTests {

  @Test func testUserInit() async throws {
    let userToTest = User(
      id: "12345",
      firstName: "Test",
      lastName: "User",
      username: "testUser"
    )
    #expect(userToTest.id == "12345")
    #expect(userToTest.firstName == "Test")
    #expect(userToTest.lastName == "User")
    #expect(userToTest.username == "testUser")
  }

  @Test func testUserInitFromDecoder() async throws {
    let dataString = """
      {
        "id":"12345",
        "firstName": "Test",
        "lastName": "User",
        "username": "testUser"
      }
      """
    let userData = dataString.data(using: .utf8)!
    let userToTest = try JSONDecoder().decode(User.self, from: userData)
    #expect(userToTest.id == "12345")
    #expect(userToTest.firstName == "Test")
    #expect(userToTest.lastName == "User")
    #expect(userToTest.username == "testUser")
  }

  @Test func testUserInitFromRawData() async throws {
    let dataString = """
      {
        "id":"12345",
        "firstName": "Test",
        "lastName": "User",
        "username": "testUser"
      }
      """
    let userToTest = User(rawValue: dataString)
    #expect(userToTest != nil)
    #expect(userToTest!.id == "12345")
    #expect(userToTest!.firstName == "Test")
    #expect(userToTest!.lastName == "User")
    #expect(userToTest!.username == "testUser")
  }

  @Test func testerUserEncodeDecode() async throws {
    let userToTest = User(
      id: "12345",
      firstName: "Test",
      lastName: "User",
      username: "testUser"
    )
    let encodedUser = try JSONEncoder().encode(userToTest)
    let decodedUser = try JSONDecoder().decode(User.self, from: encodedUser)
    #expect(decodedUser.id == "12345")
    #expect(decodedUser.firstName == "Test")
    #expect(decodedUser.lastName == "User")
    #expect(decodedUser.username == "testUser")
  }
}
