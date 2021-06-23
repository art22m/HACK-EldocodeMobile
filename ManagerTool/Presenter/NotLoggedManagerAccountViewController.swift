//
//  ManagerAccountViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 22.06.2021.
//

import UIKit
import FirebaseAuth

class NotLoggedManagerAccountViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        // Close keyboard
        let tapOutsideKeyboard = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutsideKeyboard)
        
        passwordTextField.isSecureTextEntry = true
        errorLabel.isHidden = true
        errorLabel.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // when touch outside
    }

    @IBAction func signinTap(_ sender: Any) {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.isHidden = false
            errorLabel.text = "Введите логин и пароль"
            print("Missing field data")
            return
        }
        
        Auth.auth().signIn(withEmail: login, password: password) { [weak self] authResult, error in
//            guard let strongSelf = self else { return }
            self?.errorLabel.isHidden = true
            
            guard error == nil else {
                if let error = error as NSError? {
                    guard let errorCode = AuthErrorCode(rawValue: error.code) else {
                        self?.errorLabel.text = "Неизвестная ошибка"
                        print("there was an error logging in but it could not be matched with a firebase code")
                        return
                    }
                    switch errorCode {
                    case .invalidEmail:
                        self?.errorLabel.text = "Неправильный формат почты"
                        print("invalid email")
                    case .networkError:
                        self?.errorLabel.text = "Проверьте подключение к интернету"
                        print("network error")
                    case .userNotFound:
                        self?.errorLabel.text = "Пользователь не найден"
                        print("network error")
                    case .tooManyRequests:
                        self?.errorLabel.text = "Слишком много запросов"
                        print("network error")
                    case .wrongPassword:
                        self?.errorLabel.text = "Не верный пароль"
                        print("network error")
                    default:
                        self?.errorLabel.text = "Ошибка - попробуйте еще раз"
                        print("unhandled error")
                    }
                    self?.errorLabel.isHidden = false
                }
                return
            }
            
            // In case of success log in
            _ = self?.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
}
