//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 17.06.2023.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    
    @StateObject var vm: AppViewModel
    @State private var showScannerSheet: Bool = false
    
    private let textContentType: [
        (title: String, textContentType: DataScannerViewController.TextContentType?)
    ] = [
        ("All", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
    var body: some View {
        switch vm.dataScannerAcessedStatus {
        case .scannerAvailable:
            Text("Scanner is avaliable")
            mainView
        case .cameraNotAvailable:
            Text("Your device does,t have a camera")
        case .scannerNotAvailable:
            Text("Your device does,t have support for scanning barcode with this app")
        case .cameraAccessNotGranted:
            Text("Place provide access to yhe camera in settings")
        case .notDetermined:
            // Test UI
            //mainView
            Text("Request camera access")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: AppViewModel())
    }
}

extension ContentView {
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            isScanning: $vm.startScanning,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems
        )
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea()
        .id(vm.dataScannerViewId)
        .sheet(isPresented: .constant(true)) {
            containerView
                .padding()
                .background(.ultraThinMaterial)
                .presentationDetents([.medium, .fraction(0.35)])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .clearModalBackground()
        }
        .onChange(of: vm.scanType) { _ in
            vm.recognizedItems = []
        }
        .onChange(of: vm.textContentType) { _ in
            vm.recognizedItems = []
        }
        .onChange(of: vm.recognizesMultipleItems) { _ in
            vm.recognizedItems = []
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack {
                Picker("Scan Type", selection: $vm.scanType) {
                    Text("Barcode")
                        .tag(ScanType.barcode)
                    Text("Text")
                        .tag(ScanType.text)
                }
                .font(.headline)
                .fontWeight(.medium)
                .pickerStyle(.segmented)
            }
            Toggle(isOn: $vm.recognizesMultipleItems) {
                Text("Scan multiple")
                    .font(.headline)
                    .fontWeight(.medium)
            }
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentType, id: \.self.textContentType) { settings in
                        Text("\(settings.title)")
                            .tag(settings.textContentType)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
            }
            HStack(alignment: .center, spacing: 10) {
                Text(vm.headerText)
                ProgressView()
                    .isHidden(!vm.recognizedItems.isEmpty)
                    .progressViewStyle(.circular)
            }
        }
        .padding()
    }
    
    private var containerView: some View {
        VStack {
            headerView
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, content: {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                        case .text(let text):
                            Text(text.transcript)
                        @unknown default:
                            Text("Unknown data")
                        }
                    }
                })
            }
            Button {
                vm.startScanning.toggle()
            } label: {
                HStack {
                    Text("Start Scann")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                .frame(width: 380, height: 40)
                .background(Color.blue)
                .cornerRadius(25)
            }
        }
    }

}
