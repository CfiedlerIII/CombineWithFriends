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

  @Test func testUserEncodeDecode() async throws {
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

  @Test func testUsersInit() async throws {
    let user = User(
      id: "12345",
      firstName: "Test",
      lastName: "User",
      username: "testUser"
    )
    let juniorUser = User(
      id: "12346",
      firstName: "Junior",
      lastName: "User",
      username: "jUser"
    )
    let usersToTest: [User] = [user, juniorUser]
    #expect(usersToTest.count == 2)
    #expect(usersToTest[0].id == "12345")
    #expect(usersToTest[0].firstName == "Test")
    #expect(usersToTest[0].lastName == "User")
    #expect(usersToTest[0].username == "testUser")
    #expect(usersToTest[1].id == "12346")
    #expect(usersToTest[1].firstName == "Junior")
    #expect(usersToTest[1].lastName == "User")
    #expect(usersToTest[1].username == "jUser")
  }

  @Test func testUsersInitFromDecoder() async throws {
    let dataString = """
      {
        "users": [
          {
            "id":"12345",
            "firstName": "Test",
            "lastName": "User",
            "username": "testUser"
          },
          {
            "id":"12346",
            "firstName": "Junior",
            "lastName": "User",
            "username": "jUser"
          }
        ]
      }
      """
    let userData = dataString.data(using: .utf8)!
    let usersToTest = try JSONDecoder().decode(Users.self, from: userData)
    #expect(usersToTest.users.count == 2)
    #expect(usersToTest.users[0].id == "12345")
    #expect(usersToTest.users[0].firstName == "Test")
    #expect(usersToTest.users[0].lastName == "User")
    #expect(usersToTest.users[0].username == "testUser")
    #expect(usersToTest.users[1].id == "12346")
    #expect(usersToTest.users[1].firstName == "Junior")
    #expect(usersToTest.users[1].lastName == "User")
    #expect(usersToTest.users[1].username == "jUser")
  }

  @Test func testUsersInitFromRawData() async throws {
    let dataString = """
      {
        "users": [
          {
            "id":"12345",
            "firstName": "Test",
            "lastName": "User",
            "username": "testUser"
          },
          {
            "id":"12346",
            "firstName": "Junior",
            "lastName": "User",
            "username": "jUser"
          },
        ]
      }
      """
    guard let usersToTest = Users(rawValue: dataString) else {
      #expect(Bool(false), "Failed to initialize Users from raw string")
      return
    }
    #expect(usersToTest.users.count == 2)
    #expect(usersToTest.users[0].id == "12345")
    #expect(usersToTest.users[0].firstName == "Test")
    #expect(usersToTest.users[0].lastName == "User")
    #expect(usersToTest.users[0].username == "testUser")
    #expect(usersToTest.users[1].id == "12346")
    #expect(usersToTest.users[1].firstName == "Junior")
    #expect(usersToTest.users[1].lastName == "User")
    #expect(usersToTest.users[1].username == "jUser")
  }

  @Test func testUsersEncodeDecode() async throws {
    let user = User(
      id: "12345",
      firstName: "Test",
      lastName: "User",
      username: "testUser"
    )
    let juniorUser = User(
      id: "12346",
      firstName: "Junior",
      lastName: "User",
      username: "jUser"
    )
    let usersToTest = Users([user, juniorUser])
    let encodedUsers = try JSONEncoder().encode(usersToTest)
    let decodedUsers = try JSONDecoder().decode(Users.self, from: encodedUsers)
    #expect(decodedUsers.users.count == 2)
    #expect(decodedUsers.users[0].id == "12345")
    #expect(decodedUsers.users[0].firstName == "Test")
    #expect(decodedUsers.users[0].lastName == "User")
    #expect(decodedUsers.users[0].username == "testUser")
    #expect(decodedUsers.users[1].id == "12346")
    #expect(decodedUsers.users[1].firstName == "Junior")
    #expect(decodedUsers.users[1].lastName == "User")
    #expect(decodedUsers.users[1].username == "jUser")
  }
}
