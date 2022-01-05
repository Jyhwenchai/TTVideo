//
//  PlayListView+ViewModifier.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2022/1/5.
//

import SwiftUI
import UIKit

struct PlayListNavigationBar: ViewModifier {
    
    @Binding var showOverlay: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showOverlay = true }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "square.grid.3x1.below.line.grid.1x2")
                            .foregroundColor(.blue)
                    }
                }
            }
    }
}
