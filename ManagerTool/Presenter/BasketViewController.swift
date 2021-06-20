//
//  BasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import AVFoundation
import QRCodeReader

var productsNames: [String] = ["Смартфон Apple iPhone 11 128GB Black (MHDH3RU/A)", "Кондиционер Candy ACI-09HTR03/R3", "Ноутбук Acer TravelMate TMB118-M-C6UT", "LED телевизор 50 Toshiba 50U5069", "Робот-пылесос Tefal X-Plorer Serie 40 RG7267WH", "Вентилятор напольный Electrolux EFF-113D", "Холодильник Indesit ITS 4180 W", "Погружной блендер Philips HR2545/00", "Электрическая варочная панель Samsung NZ64T3516BK"]


class BasketViewController: UIViewController {
    
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
    
    @IBOutlet weak var productListTableView: UITableView!
    let noCameraAlert = UIAlertController(title: "Камера не работает", message: "Возникла ошибка при работе с камерой", preferredStyle: .alert)
    let qrCodeReaderNotAvailable = UIAlertController(title: "Устройство не поддерживает считывание QR", message: "Возникла ошибка при работе с QRCodeReader", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !QRCodeReader.isAvailable() {
            self.present(qrCodeReaderNotAvailable, animated: true)
        }
        
        // Alerts
        noCameraAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        qrCodeReaderNotAvailable.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        // Initialize the table
        productListTableView.register(CustomBasketTableViewCell.nib(), forCellReuseIdentifier: CustomBasketTableViewCell.identifier)
        productListTableView.dataSource = self
        productListTableView.allowsSelection = false
    }
}

extension BasketViewController {
    func checkCamera() -> Bool{
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.present(noCameraAlert, animated: true)
            return false
        } else {
            return true
        }
    }
}

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomBasketTableViewCell.identifier, for: indexPath) as? CustomBasketTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: .init(vendorCode: "123", name: productsNames[indexPath.row], logo: nil))
        return cell
    }
    
    // Swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            productsNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension BasketViewController {
    // MARK: - IBAction
    @IBAction func QRCodeButton(_ sender: Any) {
        if !checkCamera() { return }
        
        QRReaderViewController.completionBlock = { (result: QRCodeReaderResult?) in
            print(result ?? "No information =(")
        }

        QRReaderViewController.modalPresentationStyle = .formSheet

        present(QRReaderViewController, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }
}
