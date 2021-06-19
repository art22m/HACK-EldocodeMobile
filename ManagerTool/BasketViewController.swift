//
//  BasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import AVFoundation
import QRCodeReader

class BasketViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !QRCodeReader.isAvailable() {
            print("Not available!")
        }
    }
    
    lazy var QRReaderViewController: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
}

extension BasketViewController {
    // MARK: - IBAction
    @IBAction func QRCodeButton(_ sender: Any) {
            // Or by using the closure pattern
        
        print(123)
        
        QRReaderViewController.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
        }

        // Presents the readerVC as modal form sheet
        QRReaderViewController.modalPresentationStyle = .formSheet

        present(QRReaderViewController, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        
        print(123)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }
}
