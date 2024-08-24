//
//  ContentView.swift
//  SwipeableFullscreenCoverExample
//
//  Created by Demirhan Mehmet Atabey on 17.06.2024.
//

import SwiftUI
import SwipeableFullscreenCover

struct ContentView: View {
  @State private var change: Bool = false
  @State private var present: Bool = false
  
  var body: some View {
    HStack {
      Button {
        change.toggle()
      } label: {
        Text("Fullscreen")
      }
      .swipeableFullscreenCover(id: FullScreenCoverTab.first, isPresented: $change) {
        ZStack {
          VStack {
            ScrollView {
              VStack {
                ForEach(0..<15) { _ in
                  RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .frame(height: 150)
                }
              }
              .padding(.horizontal)
            }
          }
          .padding(.top, 48)
        }
      }
      .swipeToDismissBehavior(.enabled(showsIndicators: false))
      .customBackground {
        Color.init(white: 0.1)
          .overlay(alignment: .topLeading) {
            GeometryReader { geo in
              Color.purple.opacity(0.4)
                .frame(width: 450.0, height: 450.0)
                .clipShape(Circle())
                .blur(radius: 120)
                .offset(x: geo.size.width * 0.5, y: geo.size.height * 0.2)
              Color.indigo.opacity(0.4)
                .frame(width: 450.0, height: 450.0)
                .clipShape(Circle())
                .blur(radius: 80)
                .offset(x: geo.size.width * 0.3, y: geo.size.height * 0.4)
              Color.pink.opacity(0.4)
                .frame(width: 450.0, height: 450.0)
                .clipShape(Circle())
                .blur(radius: 80)
                .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.6)
            }
          }
      }
      Button {
        present = true
      } label: {
        Text("Regular")
      }
    }
    .sheet(isPresented: $present) {
      Color.purple.ignoresSafeArea()
    }
    .foregroundColor(change ? .red : .blue)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .ignoresSafeArea()
  }
}

struct FullScreenCoverTab {
  static let first = "first"
  static let second = "second"
  static let third = "third"
}

#Preview {
  ContentView()
}
