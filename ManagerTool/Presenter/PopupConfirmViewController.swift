//
//  AddToBasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import SDWebImage

class PopupConfirmViewController: UIViewController {
    // MARK: - IBOutlet
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var popupWindow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        cancelButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        popupWindow.layer.cornerRadius = 20

        
//        logoImageView.sd_setImage(with: URL(string:  ?? ""), placeholderImage: UIImage(named: "ProductLogoPlaceholder"))
//        nameLabel.text = productName != nil ? productName : "Нет названия"
        
        self.showAnimate()
        
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelTap(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func addTap(_ sender: Any) {
        removeAnimate()
    }
    
    // MARK: - Animations
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.8
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        } completion: { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
}
