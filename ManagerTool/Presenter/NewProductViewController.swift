//
//  NewProductViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import UIKit
import AVFoundation
import QRCodeReader

class NewProductViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.showSwitchCameraButton  = false
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView         = true
            $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.4)
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
      }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var QRCodeButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var BarcodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBAction
    @IBAction func QRTap(_ sender: Any) {
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self

        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
              if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
              }
        }

        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func SearchTap(_ sender: Any) {
        
    }
    
    @IBAction func BarcodeTap(_ sender: Any) {
        
    }
}

// Scan Permission Check
extension NewProductViewController {
    private func checkScanPermissions() -> Bool {
        do {
          return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
          let alert: UIAlertController

          switch error.code {
          case -11852:
            alert = UIAlertController(title: "Ошибка", message: "Это приложение не авторизовано для использования камеры заднего вида.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Настройки", style: .default, handler: { (_) in
              DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
              }
            }))

            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
          default:
            alert = UIAlertController(title: "Ошибка", message: "Сканнер не поддерживается данным устройством", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
          }

          present(alert, animated: true, completion: nil)

          return false
        }
    }
}

// MARK: - QRCodeReader Settings
extension NewProductViewController {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true) { [weak self] in
          let alert = UIAlertController(
            title: "QRCodeReader",
            message: String (format:"%@ (of type %@)", result.value, result.metadataType),
            preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

          self?.present(alert, animated: true, completion: nil)
        }
      }

      func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
      }
}
