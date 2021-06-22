//
//  BasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class ProductListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emptyBasketImage: UIImageView!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    var productsList: [Product] = [Product.init(vendorCode: "71240236", name: "Контейнер Tefal Masterseal Fresh 0,2 л (K3010112)", price: "690", pictureURL: nil, productURL: "https://www.eldorado.ru/cat/detail/kontejner-tefal-clip-close-0-2-l-k3010112/")]
    
    private var managerID: String? = nil
    private lazy var db = Firestore.firestore()
    private let saveActions = SaveActions()
    let alertNoLogin = UIAlertController(title: "Вы не авторизованы.",
                                         message: "Пожалуйста, войдите под своим уникальным номером.",
                                         preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyBasketImage.isHidden = true
                        
        // Initialize the table
        productListTableView.register(CustomProductsListTableViewCell.nib(), forCellReuseIdentifier: CustomProductsListTableViewCell.identifier)
        productListTableView.dataSource = self
        productListTableView.allowsSelection = false
        productListTableView.rowHeight = 100
        
        // Alerts
        let okAction = UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default) {
                UIAlertAction in
            if let ManagerAccountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ManagerAccount") as? ManagerAccountViewController {
                if let navigator = self.navigationController {
                      navigator.pushViewController(ManagerAccountViewController, animated: true)
                }
            }
        }
        alertNoLogin.addAction(okAction)
}
    
    
    // MARK: - IBAction
    @IBAction func historyTap(_ sender: Any) {
        historyButton.animateBounce()
    }
    
    @IBAction func addTap(_ sender: Any) {
        addButton.animateBounce()
    }
    
    @IBAction func accountTap(_ sender: Any) {
        accountButton.animateBounce()
    }
    
    @IBAction func sendTap(_ sender: Any) {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            if let id = managerID {
                saveActions.saveProducts(products: productsList, manager: id, customerPhone: nil)
            }
        } else {
            self.present(alertNoLogin, animated: true, completion: nil)
        }
    }
}

// MARK: - TableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (productsList.isEmpty) {
            emptyBasketImage.isHidden = false
            productListTableView.isHidden = true
        } else {
            emptyBasketImage.isHidden = true
            productListTableView.isHidden = false
        }
        
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomProductsListTableViewCell.identifier, for: indexPath) as? CustomProductsListTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: .init(vendorCode: productsList[indexPath.row].vendorCode, name: productsList[indexPath.row].name, price: productsList[indexPath.row].price, pictureURL: productsList[indexPath.row].pictureURL))
        
        return cell
    }
        
    // Swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            productsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func addProduct(product: Product) {
        productsList.append(product)
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

// Button Animation
extension UIView {
    func animateBounce(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                            self.transform = CGAffineTransform.identity
                       },
                       completion: { Void in()  }
                       )
    }
    
    func animateZoom(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
                self.transform = .identity
                }) { (animationCompleted: Bool) -> Void in }
    }
}
