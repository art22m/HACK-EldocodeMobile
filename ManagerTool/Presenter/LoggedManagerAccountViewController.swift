//
//  LoggedManagerAccountViewController.swift
//  ManagerTool
//
//  Created by Артём Мурашко on 23.06.2021.
//

import UIKit
import FirebaseAuth

class LoggedManagerAccountViewController: UIViewController {
    @IBOutlet weak var plateLabelView: UIView!
    @IBOutlet weak var accountInfoLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plateLabelView.layer.cornerRadius = 10
        let email = FirebaseAuth.Auth.auth().currentUser?.email
        
        accountInfoLabel.text = "Вы вошли под почтой: \(email ?? "нет информации")"
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            // In case of success log out
            _ = self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Sign-out error occured")
        }
        
        
    }
}
