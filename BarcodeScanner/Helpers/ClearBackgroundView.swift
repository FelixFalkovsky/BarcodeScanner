//
//  ClearBackgroundView.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 18.06.2023.
//

import SwiftUI

/*
 .clearModalBackground() - модификатор для вью
 используется для очистки бэкграунда вью при .fullScreenCover
 */

struct ClearBackgroundView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        lazy var view = SuperviewRecolourView()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

/*
 Конвертировать вью к общему типу AnyView
 */
extension View {

    func clearModalBackground() -> some View {
      self.modifier(ClearBackgroundViewModifier())
    }

}

@MainActor
class SuperviewRecolourView: UIView {
    override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            print("ERROR: Failed to get parent view to make it clear")
            return
        }
        parentView.backgroundColor = .clear
    }
}
