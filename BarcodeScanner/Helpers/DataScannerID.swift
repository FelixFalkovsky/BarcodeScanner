//
//  DataScannerID.swift
//  BarcodeScanner
//
//  Created by Felix Falkovsky on 18.06.2023.
//

import Foundation
import VisionKit

struct DataScannerID: Hashable {
    var scanType: ScanType
    var recognizesMultipleItems: Bool
    var textContentType: DataScannerViewController.TextContentType?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
    }
}
