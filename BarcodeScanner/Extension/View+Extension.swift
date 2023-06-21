//
//  View+Extension.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 20.06.2023.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
