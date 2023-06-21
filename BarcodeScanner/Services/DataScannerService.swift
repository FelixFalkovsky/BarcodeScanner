//
//  DataScannerService.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 18.06.2023.
//

import Foundation
import SwiftUI
import AVKit
import VisionKit

@MainActor
class DataScannerService {
    
    var dataScannerAcessedStatus: DataScannerAccessStatusType?
    
    var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    var isStartScanning: Bool {
        return false
    }
    
    func requestDataScannerAccessStatus() async {
        guard
            UIImagePickerController.isSourceTypeAvailable(.camera)
        else {
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
