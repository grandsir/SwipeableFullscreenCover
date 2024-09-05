//
//  DragGestureExtension.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 24.08.2024.
//

import SwiftUI

internal extension DragGesture {
  enum DragState: Equatable {
    case none
    case changed(value: DragGesture.Value)
    case ended(value: DragGesture.Value)
  }
}
