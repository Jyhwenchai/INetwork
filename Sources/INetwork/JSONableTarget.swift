//
//  File.swift
//  
//
//  Created by 蔡志文 on 7/4/23.
//

import Foundation
import Moya

// MARK: - Concrete Target Type
public class JSONableTarget<Parameter>: APITargetType where Parameter: JSONParameterConvertable {
  open var parameter: Parameter
  public var taskWrapper: APIJSONableTask {
    let encoding: ParameterEncoding = method == .post ? JSONEncoding.default : URLEncoding.default
    return .init(parameters: parameter.toJSON(), encoding: encoding)
  }
  public var path: String { "" }
  public var baseURL: URL { URL(string: "")! }
  public var method: APIMethod { .post }
  public var headers: [String : String]? { .none }
  public init(parameter: Parameter) {
    self.parameter = parameter
  }
}

extension JSONableTarget where Parameter == EmptyParameter {
  convenience init() {
    self.init(parameter: EmptyParameter())
  }
}

public protocol JSONParameterConvertable {
  func toJSON() -> [String: Any]
}

struct EmptyParameter: JSONParameterConvertable {
  func toJSON() -> [String : Any] { [:] }
}


