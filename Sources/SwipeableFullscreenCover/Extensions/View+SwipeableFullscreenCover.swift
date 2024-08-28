//
//  View+swipeableFullscreenCover.swift
//  SwipeableFullscreenCover
//
//  Created by Demirhan Mehmet Atabey on 29.05.2024.
//

import SwiftUI

extension View {
  /// Presents a highly customizable, swipeable modal view that covers as much of the screen as
  /// possible when binding to a Boolean value you provide is true and displays.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether
  ///     to present the sheet.
  ///   - onDismiss: The closure to execute when dismissing the modal view.
  ///   - content: A closure that returns the content of the modal view.
  public func swipeableFullscreenCover<T> (
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> T
  ) -> some View where T: View {
    SwipeableFullscreenCoverView(
      isPresented: isPresented,
      parent: self,
      content: content
    )
  }
}
