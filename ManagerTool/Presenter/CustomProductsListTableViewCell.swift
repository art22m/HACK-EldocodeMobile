//
//  CustomBasketTableViewCell.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import SDWebImage

class CustomProductsListTableViewCell: UITableViewCell {

    @IBOutlet weak var productLogoImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productVendorCodeLabel: UILabel!
    
    static let identifier = "CustomBasketTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "CustomBasketTableViewCell", bundle: nil)
    }
        

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let separator = UIView(frame: CGRect(x: 20 + productLogoImageView.bounds.width, y: bounds.size.height - 0.5, width: bounds.size.width, height: 1.5))
        separator.backgroundColor = UIColor.darkGray
        contentView.addSubview(separator)
        
    }
    
    func configure(with pattern: ProductsListCellPattern) {
        if let name = pattern.name {
            self.productNameLabel.text = name
        } else {
            self.productNameLabel.text = "Неизвестно"
        }
        
        if let pictureURL = pattern.pictureURL {
            self.productLogoImageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: UIImage(named: "ProductLogoPlaceholder"))
        } else {
            self.productLogoImageView.image = UIImage(named: "ProductLogoPlaceholder")
        }
        
        if let price = pattern.price {
            self.productPriceLabel.text = "Стоимость: " + price + "₽"
        } else {
            self.productPriceLabel.text = "Неизвестно"
        }
        
        if let id = pattern.vendorCode {
            self.productVendorCodeLabel.text = "Артикул: " + id
        } else {
            self.productVendorCodeLabel.text = "Неизвестно"
        }
    }
}
