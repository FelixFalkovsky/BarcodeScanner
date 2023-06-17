//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 17.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        switch vm.dataScannerAcessedStatus {
        case .scannerAvailable:
            Text("Scanner is avaliable")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
