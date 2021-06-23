//
//  NewProductViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import UIKit
import AVFoundation
import QRCodeReader
import BarcodeScanner

class ProductAddMethodsViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.showSwitchCameraButton  = false
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView         = true
            $0.rectOfInterest          = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
      }()
    
    let webParser = EldoradoWebSiteParser()
    
    // MARK: - IBOutlet
    @IBOutlet weak var QRCodeButton: UIButton!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var BarcodeButton: UIButton!
    
    let alertNotInDB = UIAlertController(title: "Товар не состоит в базе данных",
                                              message: nil,
                                              preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertNotInDB.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
    }
    
    // MARK: - IBAction
    @IBAction func QRTap(_ sender: Any) {
        QRCodeButton.animateZoom()
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self

        present(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func SearchTap(_ sender: Any) {
        SearchButton.animateZoom()
    }
    
    @IBAction func BarcodeTap(_ sender: Any) {
        BarcodeButton.animateZoom()
        guard checkScanPermissions() else { return }
        
        let barcodeVC = makeBarcodeScannerViewController()
        barcodeVC.modalPresentationStyle = .formSheet
        
        present(barcodeVC, animated: true, completion: nil)
    }
}

// Scan Permission Check
extension ProductAddMethodsViewController {
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

// MARK: - BarcodeScanner Settings
extension ProductAddMethodsViewController: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate  {
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
       let viewController = BarcodeScannerViewController()
       viewController.codeDelegate = self
       viewController.errorDelegate = self
       viewController.dismissalDelegate = self
       return viewController
     }
    
    // MARK: - BarcodeScannerCodeDelegate
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        controller.dismiss(animated: true, completion: nil)
        self.addProduct(url: code)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            controller.resetWithError()
        }
    }
    
    // MARK: - BarcodeScannerErrorDelegate
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
  }

    // MARK: - BarcodeScannerDismissalDelegate
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - QRCodeReader Settings
extension ProductAddMethodsViewController {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        self.addProduct(url: result.value)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}

extension ProductAddMethodsViewController {
    func addProduct(url: String) {
        var url = url
        if (url.first?.isNumber == true) {
            let fetchedBarcodeURL = webParser.getURLByBarcode(barcode: url)
            if let barURL = fetchedBarcodeURL {
                url = barURL
            } else {
                self.present(alertNotInDB, animated: true, completion: nil)
                return
            }
        }
        
        let fetchedData = webParser.getProductData(from: url)
        // IF QR Code doesn't contain https protocol
        if (url.first != "h") {
            url.insert(contentsOf: "https://", at: url.startIndex)
        }
        
        print(url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (fetchedData.name == nil) {
                let alertFailure = UIAlertController(title: "Товар не найден",
                                                    message: "Попробуйте отсканировать код еще раз или проверьте код на целостность",
                                                    preferredStyle: .alert)
                alertFailure.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
                self.present(alertFailure, animated: true, completion: nil)
                return
            }
            
            let alertSuccess = UIAlertController(title: "Найден товар",
                                                 message: "Название: \(fetchedData.name ?? "Не найдено")) \nАртикул: \(fetchedData.vendorCode ?? "Не найден") ",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Добавить", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                if let rootVC = self.navigationController?.viewControllers.first as? ProductListViewController {
                    rootVC.addProduct(product: Product.init(vendorCode: fetchedData.vendorCode, name: fetchedData.name, price: fetchedData.price, pictureURL: fetchedData.pictureURL, productURL: url))
                }
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel)
            
            alertSuccess.addAction(okAction)
            alertSuccess.addAction(cancelAction)
            
            self.present(alertSuccess, animated: true, completion: nil)
        }
    }
}
