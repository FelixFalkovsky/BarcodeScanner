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
    
    init(scanType: ScanType, recognizesMultipleItems: Bool, textContentType: DataScannerViewController.TextContentType? = nil) {
        self.scanType = scanType
        self.recognizesMultipleItems = recognizesMultipleItems
        self.textContentType = textContentType
    }
    
    func hash(into hasher: inout Hasher) -> Int {
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
}
