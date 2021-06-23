//
//  BasketViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 20.06.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProductListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var emptyBasketImage: UIImageView!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    var productsList: [Product] = []
    
    private var managerID: String? = nil
    private lazy var db = Firestore.firestore()
    private let saveActions = SaveActions()
    let alertNoLogin = UIAlertController(title: "Вы не авторизованы",
                                         message: "Пожалуйста, войдите под своим уникальным номером",
                                         preferredStyle: .alert)
    let alertQuestion = UIAlertController(title: "Сохранить заказ",
                                              message: "У клиента есть карта лояльности?",
                                              preferredStyle: .alert)
    let alertInputPhone = UIAlertController(title: "Номер телефона",
                                              message: "Для сохранения требуется номер телефона клиента",
                                              preferredStyle: .alert)
    let alertEmptyBasket = UIAlertController(title: "Корзина пуста",
                                              message: "Пожалуйста, добавьте товары в корзину для сохранения",
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
                self.performSegue(withIdentifier: "toNotLogged", sender: self)
            }
    
        alertNoLogin.addAction(okAction)
        
        // Alert #2
        alertQuestion.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alertQuestion.addAction(UIAlertAction(title: "Да", style: .default, handler: { [self] action in
            self.present(alertInputPhone, animated: true, completion: nil)
        }))
        alertQuestion.addAction(UIAlertAction(title: "Нет", style: .default, handler: { [self] action in
            sendToDataBase()
        }))
        
        // Alert #3
        alertInputPhone.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        alertInputPhone.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { [self] action in
            let textField = alertInputPhone.textFields![0] as UITextField
            var text: String = "empty"
            if (textField.text != "") { text = textField.text ?? "empty" }
            sendToDataBase(customerPhone: text)
        }))
        alertInputPhone.addTextField()
        alertInputPhone.textFields![0].placeholder = "+79991231212"
        
        // Alert #4
        alertEmptyBasket.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
}
    
    
    // MARK: - IBAction
    @IBAction func saveTap(_ sender: Any) {
        if productsList.isEmpty {
            self.present(alertEmptyBasket, animated: true, completion: nil)
            return
        }
        
        saveButton.animateBounce()
        if FirebaseAuth.Auth.auth().currentUser == nil {
            self.present(alertNoLogin, animated: true, completion: nil)
        } else {
            self.present(alertQuestion, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTap(_ sender: Any) {
        addButton.animateBounce()
    }
    
    @IBAction func accountTap(_ sender: Any) {
        accountButton.animateBounce()
        if FirebaseAuth.Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toLogged", sender: self)
        } else {
            performSegue(withIdentifier: "toNotLogged", sender: self)
        }
    }
    
    private func sendToDataBase(customerPhone: String = "empty") {
        guard productsList.isEmpty == false else { return }
        let managerID: String = FirebaseAuth.Auth.auth().currentUser?.uid ?? "no-data"
        print(customerPhone)
        let docID = saveActions.saveProducts(products: productsList, managerID: managerID, customerPhone: customerPhone)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5)  {
            self.productsList.removeAll()
            self.productListTableView.reloadData()
        }
        
        if let QRGeneratorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRGenerator") as? QRGeneratorViewController {
            QRGeneratorViewController.docID = docID
            if let navigator = self.navigationController {
                  navigator.pushViewController(QRGeneratorViewController, animated: true)
            }
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
