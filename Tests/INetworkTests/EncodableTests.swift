//
//  File.swift
//  
//
//  Created by 蔡志文 on 7/3/23.
//

import XCTest
@testable import INetwork

final class EncodableTests: XCTestCase {
  func testEncodableUserRequest() {
    let target = GetUserEncodableTarget(parameter: GetUserParameter(id: "5"))
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
}

class GetUserEncodableTarget: EncodableTarget<GetUserParameter> {
  override var baseURL: URL { URL(string: "https://630323aec6dda4f287c3bd32.mockapi.io")! }
  override var path: String { "/api/v1/user/\(parameter.id)" }
  override var method: APIMethod { .get }
}

