//
//  DetectionScrollView.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Foundation
import SwiftUI

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct DetectionScrollView<Content: View>: View {
    
    @Binding var hasScrolledToEnd: Bool
    let content: () -> Content
    
    @State private var visibleContentHeight: CGFloat = 0
    @State private var totalContentHeight: CGFloat = 0
    
    init(hasScrolledToEnd: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._hasScrolledToEnd = hasScrolledToEnd
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                offsetReader
                content()
                    .overlay(content:  {
                        GeometryReader(content: { geometry in
                            Color.clear.onAppear {
                                self.totalContentHeight = geometry.frame(in: .global).height
                            }
                        })
                    })
            }
//            .onAppear {
//                self.totalContentHeight = geometry.frame(in: .global).height
//            }
            .overlay(content: {
                GeometryReader(content: { geometry in
                    Color.clear
                        .onAppear {
                            self.visibleContentHeight = geometry.frame(in: .global).height
                        }
                })
            })
            .coordinateSpace(name: "frameLayer")
            .onPreferenceChange(OffsetPreferenceKey.self, perform: { offset in
                if totalContentHeight < visibleContentHeight {
                    hasScrolledToEnd = false
                    return
                }
                if totalContentHeight != 0 && visibleContentHeight != 0 {
                    if (totalContentHeight - visibleContentHeight) + offset <= 0 {
                        hasScrolledToEnd = true
                    } else {
                        hasScrolledToEnd = false
                    }
                } else {
                    hasScrolledToEnd = false
                }
            })
        }
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("frameLayer")).maxY
                )
        }
        .frame(height: 0)
    }
}
