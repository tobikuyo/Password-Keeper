//
//  AddPasswordViewController.swift
//  iPasswordKeeper
//
//  Created by Tobi Kuyoro on 23/11/2019.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController {
    
    var passwordController: PasswordController?
    var password: Password?

    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var passwordTextView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        
        guard let website = websiteTextField.text,
            let passwordString = passwordTextView.text,
            !website.isEmpty else { return }
        
        if let password = password {
            passwordController?.updatePassword(password: password, with: passwordString, website: website)
        } else {
            passwordController?.cratePassword(with: passwordString, website: website)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        title = password?.passwordString ?? "Add Password"
        
        websiteTextField.text = password?.website
        passwordTextView.text = password?.passwordString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
