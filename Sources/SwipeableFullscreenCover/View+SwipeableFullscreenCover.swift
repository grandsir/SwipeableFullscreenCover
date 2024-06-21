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
  public func swipeableFullscreenCover<T, R: Equatable> (
    id: R,
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> T
  ) -> some View where T: View {
    return SwipeableFullscreenCoverView(
      isPresented: isPresented,
      content: content,
      parent: self,
      id: id
    )
  }
  
  /// Presents a highly customizable, swipeable modal view that covers as much of the screen as
  /// possible when binding to a Boolean value you provide is true and displays.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether
  ///     to present the sheet.
  ///   - onDismiss: The closure to execute when dismissing the modal view.
  ///   - content: A closure that returns the content of the modal view.
  public func swipeableFullscreenCover<T> (
    id: String,
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> T
  ) -> some View where T: View {
    return SwipeableFullscreenCoverView(
      isPresented: isPresented,
      content: content,
      parent: self,
      id: id
    )
  }
}
