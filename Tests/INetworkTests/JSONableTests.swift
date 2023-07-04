import XCTest
@testable import INetwork

final class INetWorkTests: XCTestCase {
  func testGetUserRequest() {
    let target = GetUserTarget(parameter: GetUserParameter(id: "5"))
    let provider = APIRequest(target: target)
    let expectation = expectation(description: #function)
    provider.request { result in
      switch result {
      case .success(let resp):
        let user = try? JSONDecoder().decode(User.self, from: resp.data)
        expectation.fulfill()
        XCTAssertEqual(user?.id, "5")
      case .failure(let error):
        print(error.localizedDescription)
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 10)
  }

  func testGetUsersRequest() {
    let target = GetUsersTarget()
    let provider = APIRequest(target: target)
    let expectation = expectation(description: #function)
    provider.request { result in
      switch result {
      case .success(let resp):
        let users = try? JSONDecoder().decode([User].self, from: resp.data)
        expectation.fulfill()
        XCTAssertNotNil(users)
      case .failure(let error):
        print(error.localizedDescription)
        expectation.fulfill()
      }
    }

    wait(for: [expectation])
  }

  func testCreateUserRequest() {
    let name = (0..<8).reduce("") { partialResult, c in
      return partialResult + String("abcdefghigklmnopqrstuvwkyz".randomElement()!)
    }
    let target = CreateUserTarget(parameter: CreateUserParameter(id: "111", name: name))
    let provider = APIRequest(target: target)
    let expectation = expectation(description: #function)
    provider.request { result in
      switch result {
      case .success(let resp):
        let user = try? JSONDecoder().decode(User.self, from: resp.data)
        expectation.fulfill()
        XCTAssertNotNil(user)
      case .failure(let error):
        print(error.localizedDescription)
        expectation.fulfill()
      }
    }

    wait(for: [expectation])
  }

  typealias CurrencyTask = _Concurrency.Task
  func testAsyncGetUserRequest() {
    let target = GetUserTarget(parameter: GetUserParameter(id: "5"))
    let provider = APIRequest(target: target)
    let expectation = expectation(description: #function)
    CurrencyTask {
      do {
        let resp = try await provider.request()
        let user = try? JSONDecoder().decode(User.self, from: resp.data)
        expectation.fulfill()
        XCTAssertEqual(user?.id, "5")
      } catch {
        print("error: ", error.localizedDescription)
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 10)
  }

  func testCancelAsyncRequest() {
    let target = GetUserTarget(parameter: GetUserParameter(id: "5"))
    let provider = APIRequest(target: target)
    let expectation = expectation(description: #function)
    let task = CurrencyTask {
      do {
        let _ = try await provider.request()
        expectation.fulfill()
      } catch {
        expectation.fulfill()
        XCTAssert(error.localizedDescription ==  "Request explicitly cancelled.")
      }
    }

    task.cancel()
    wait(for: [expectation], timeout: 10)
  }
}

class GetUserTarget: JSONableTarget<GetUserParameter> {
  override var baseURL: URL { URL(string: endPoint)! }
  override var path: String { "/api/v1/user/\(parameter.id)" }
  override var method: APIMethod { .get }
}

class GetUsersTarget: JSONableTarget<EmptyParameter> {
  override var baseURL: URL { URL(string: endPoint)! }
  override var path: String { "/api/v1/user" }
  override var method: APIMethod { .get }
}

class CreateUserTarget: JSONableTarget<CreateUserParameter> {
  override var baseURL: URL { URL(string: endPoint)! }
  override var path: String { "/api/v1/user" }
}
