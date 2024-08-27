//
//  SwipeableFullscreenCoverView+Configuration.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 13.06.2024.
//

import SwiftUI

/**
 Configuration for `SwipeableFullscreenCoverView`
 */
internal class SwipeableFullscreenCoverConfiguration: ObservableObject {
  @Published var backgroundView: AnyView = .init(Color(UIColor.systemBackground))
}

extension SwipeableFullscreenCoverConfiguration: Equatable {
  static func == (lhs: Configuration, rhs: Configuration) -> Bool {
    return false
  }
}

