//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 17.06.2023.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
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
            Text("Request camera access")
        }
    }
    
    private var mainView: some View {
        VStack {
            DataScannerView(
                recognizedItems: $vm.recognizedItems,
                recognizedDataType: vm.recognizedDataType,
                recognizesMultipleItems: vm.recognizesMultipleItems
            )
            .background { Color.gray.opacity(0.3) }
            .ignoresSafeArea()
            .id(vm.dataScannerViewID)
            
            VStack {
                headerView
                ScrollView {
                    LazyVStack(alignment: .leading, content: {
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
            }
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
                .pickerStyle(.segmented)
            }
            Toggle(isOn: $vm.recognizesMultipleItems) {
                Text("Scan multiple")
            }
            
            if vm.scanType == .text {
                Picker("Text content type", selection: $vm.textContentType) {
                    ForEach(textContentType, id: \.self.textContentType) { settings in
                        Text("\(settings.title)")
                            .tag(settings.textContentType)
                    }
                }
                .pickerStyle(.segmented)
            }
            Text(vm.headerText)
                .padding(.top)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
