//
//  File.swift
//  
//
//  Created by 蔡志文 on 7/3/23.
//

import Foundation
@testable import INetwork

let endPoint = "https://630323aec6dda4f287c3bd32.mockapi.io"

struct GetUserParameter {
  let id: String
}

extension GetUserParameter: JSONParameterConvertable {
  func toJSON() -> [String : Any] {
    [
      "id": id
    ]
  }
}

struct CreateUserParameter {
  let id: String
  let name: String
}

extension CreateUserParameter: JSONParameterConvertable {
  func toJSON() -> [String : Any] {
    [
      "id": id,
      "name": name
    ]
  }
}

struct User: Codable {
  let id: String
  let name: String
}

/// Encodable
extension GetUserParameter: Encodable {}
