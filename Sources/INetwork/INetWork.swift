import Foundation
import Moya

public typealias APICompletion = (_ result: Result<APIResponse, APIError>) -> Void
public typealias APIError = MoyaError
public typealias APIMethod = Moya.Method
public typealias APIResponse = Moya.Response
public typealias APITask = Moya.Task

public protocol APITargetType<TaskWrapper>: TargetType {
  associatedtype TaskWrapper: APITaskWrapperType
  var taskWrapper: TaskWrapper { get }
}

extension APITargetType {
  public var task: Task { taskWrapper.task }
}

//MARK: - APITaskType
public protocol APITaskWrapperType {
  var task: APITask { get }
}

public struct APIJSONableTask: APITaskWrapperType {
  let parameters: [String: Any]
  let encoding:  ParameterEncoding
  public var task: APITask {
    .requestParameters(parameters: parameters, encoding: encoding)
  }
}

public struct APIEncodableTask: APITaskWrapperType {
  let parameters: Encodable
  public var task: APITask {
    .requestJSONEncodable(parameters)
  }
}
