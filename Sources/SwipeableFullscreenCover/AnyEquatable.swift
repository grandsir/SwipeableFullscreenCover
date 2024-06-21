//
//  AnyEquatable.swift
//
//
//  Created by Demirhan Mehmet Atabey on 17.06.2024.
//

import Foundation

public struct AnyEquatable {
  private let value: Any
  private let equals: (Any) -> Bool
  
  public init<T: Equatable>(_ value: T) {
    self.value = value
    self.equals = { ($0 as? T == value) }
  }
}

extension AnyEquatable: Equatable {
  static public func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    return lhs.equals(rhs.value)
  }
}
