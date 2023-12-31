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

enum ScanType: String {
    case barcode, text
}

protocol ScanOptionsProtocol: AnyObject {
    associatedtype ScanType
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAcessedStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true
    @Published var isHiddenProgressView = false
    @Published var startScanning: Bool = false
    
    private var dataScannerService = DataScannerService()
    private var dataScannerView: DataScannerView?
    private var isScannerAvailable: Bool?
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    
    var headerText: String {
        if recognizedItems.isEmpty {
            return "Scaning .. \(scanType.rawValue)"
        } else {
            return "Recognized \(recognizedItems.count) item(s)"
        }
    }
    
    func scannerAccessStatusService() async {
        await dataScannerService.requestDataScannerAccessStatus()
        isScannerAvailable = dataScannerService.isScannerAvailable
        dataScannerAcessedStatus = dataScannerService.dataScannerAcessedStatus ?? .notDetermined
    }
    
}
