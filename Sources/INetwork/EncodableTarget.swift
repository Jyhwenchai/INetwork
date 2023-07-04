//
//  File.swift
//  
//
//  Created by 蔡志文 on 7/4/23.
//

import Foundation

public class EncodableTarget<Parameter>: APITargetType where Parameter: Encodable {
  open var parameter: Parameter
  public var taskWrapper: APIEncodableTask {
    .init(parameters: parameter)
  }
  public var path: String { "" }
  public var baseURL: URL { URL(string: "")! }
  public var method: APIMethod { .post }
  public var headers: [String : String]? { .none }
  public init(parameter: Parameter) {
    self.parameter = parameter
  }
}

extension EncodableTarget where Parameter == EmptyParameter {
  convenience init() {
    self.init(parameter: EmptyParameter())
  }
}

extension EmptyParameter: Encodable {
  func encode(to encoder: Encoder) throws {}
}
