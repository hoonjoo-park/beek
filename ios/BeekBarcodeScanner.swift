import Foundation
import React
import UIKit

@objc(BeekBarcodeScanner)
class BeekBarcodeScanner: NSObject {
    
    @objc static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func openScanner() {
        DispatchQueue.main.async {
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            let scannerViewController = BeekScannerViewController()
            rootViewController?.present(scannerViewController, animated: true, completion: nil)
        }
    }
    
}
