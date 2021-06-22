//
//  ManagerAccountViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import UIKit
import FirebaseAuth

class ManagerAccountViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Close keyboard
        let tapOutsideKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutsideKeyboard)
        
        passwordTextField.isSecureTextEntry = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // when touch outside
    }

    @IBAction func signinTap(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        
        if let login = login, let password = password {
            Auth.auth().signIn(withEmail: login, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if (error != nil) {
                    print(error?.localizedDescription ?? "")
                } else {
                    print("Success")
                }
            }
        }
    }
}
