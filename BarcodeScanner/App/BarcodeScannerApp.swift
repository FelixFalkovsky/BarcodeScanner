//
//  BarcodeScannerApp.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 17.06.2023.
//

import SwiftUI

@main
struct BarcodeScannerApp: App {
    @StateObject private var vm = AppViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.scannerAccessStatusService()
                }
        }
    }
}
