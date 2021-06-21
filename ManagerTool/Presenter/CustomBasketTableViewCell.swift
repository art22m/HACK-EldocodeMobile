//
//  CustomBasketTableViewCell.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit

class CustomBasketTableViewCell: UITableViewCell {

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
    }
    
    func configure(with pattern: BasketCellPattern) {
        if let name = pattern.name {
            self.productNameLabel.text = name
        }
        
        if let logo = pattern.logo {
            self.productLogoImageView.image = logo
        } else {
            self.productLogoImageView.image = UIImage(named: "ProductLogoPlaceholder")
        }
    }
    
}
