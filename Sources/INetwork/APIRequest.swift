//
//  File.swift
//  
//
//  Created by 蔡志文 on 7/4/23.
//

import Foundation
import Moya

public class APIRequest<Target: APITargetType> {
  public let target: Target
  private let provider: MoyaProvider<Target>
  public init(target: Target) {
    self.target = target
    provider = MoyaProvider<Target>()
  }

  @discardableResult
  open func request(_ callbackQueue: DispatchQueue? = .none,
                    completion: @escaping APICompletion) -> Cancellable {
    provider.request(target, callbackQueue: callbackQueue, completion: completion)
  }

  open func request(_ callbackQueue: DispatchQueue? = .none) async throws -> APIResponse {
    try await withCheckedThrowingContinuation { continuation in
      let cancellable = request(callbackQueue) { result in
        switch result {
        case .success(let resp):
          continuation.resume(returning: resp)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
      if _Concurrency.Task.isCancelled {
        cancellable.cancel()
      }
    }
  }
}
