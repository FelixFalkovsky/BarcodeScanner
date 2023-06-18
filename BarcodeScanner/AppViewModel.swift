//
//  AppViewModel.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 17.06.2023.
//

import Foundation
import SwiftUI
import AVKit
import VisionKit

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

enum ScanType {
    case barcode, text
}

@MainActor
final class AppViewModel: ObservableObject {

    @Published var dataScannerAcessedStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true

    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }

    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAcessedStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            dataScannerAcessedStatus = isScannerAvailable ? .scannerAvailable : .cameraNotAvailable
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAcessedStatus = isScannerAvailable ? .scannerAvailable : .cameraNotAvailable
            } else {
                dataScannerAcessedStatus = .cameraAccessNotGranted
            }
        case .restricted, .denied:
            dataScannerAcessedStatus = .cameraAccessNotGranted
        default: break
        }
    }

}
