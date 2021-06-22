//
//  BasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit


class ProductListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    var productsData: [(name: String?, vendorCode: String?, price: String?, pictureURL: String?)] = [("Смартфон Apple iPhone 11 128GB Black (MHDH3RU/A)", "12345", "60000", nil)]
    
    weak var productDataDelegate: ProductDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Alerts
        
        // Initialize the table
        productListTableView.register(CustomBasketTableViewCell.nib(), forCellReuseIdentifier: CustomBasketTableViewCell.identifier)
        productListTableView.dataSource = self
        productListTableView.allowsSelection = false
        productListTableView.rowHeight = 100
    }
    
    
    // MARK: - IBAction
    @IBAction func historyTap(_ sender: Any) {
        
    }
    
    @IBAction func addTap(_ sender: Any) {
        
    }
    
    @IBAction func accountTap(_ sender: Any) {
    }
}

// MARK: - TableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomBasketTableViewCell.identifier, for: indexPath) as? CustomBasketTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: .init(vendorCode: productsData[indexPath.row].vendorCode, name: productsData[indexPath.row].name, price: productsData[indexPath.row].price, pictureURL: productsData[indexPath.row].pictureURL))
        return cell
    }
        
    // Swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            productsData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func addProduct(name: String?, vendorCode: String?, price: String?, pictureURL: String?) {
        productsData.append((name: name, vendorCode:vendorCode, price: price, pictureURL: pictureURL))
        DispatchQueue.main.async {
            self.productListTableView.reloadData()
        }
    }
}

// Pop-up Screen
extension ProductListViewController {
    func popupAddScreen() {
        let basketStoryboard = UIStoryboard(name: "AddToBasketScreen", bundle: nil)
        let addToBasketVC = basketStoryboard.instantiateViewController(withIdentifier: "AddToBasket")
        self.addChild(addToBasketVC)
        addToBasketVC.view.frame = self.view.frame
        self.view.addSubview(addToBasketVC.view)
        addToBasketVC.didMove(toParent: self)
    }
}
