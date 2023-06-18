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
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
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
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

    func clearModalBackground() -> some View {
      self.modifier(ClearBackgroundViewModifier())
    }
}
