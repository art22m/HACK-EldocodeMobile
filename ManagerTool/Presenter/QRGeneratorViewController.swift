//
//  QRGeneratorViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 23.06.2021.
//

import UIKit

class QRGeneratorViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    var docID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(docID)
        let qr = generateQRCode(from: "http://children-of-corn-eldorado.herokuapp.com/send-email/\(docID)")
        qrImage.image = qr
    }

    @IBAction func backTap(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
