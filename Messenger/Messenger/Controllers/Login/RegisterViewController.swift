//
//  LoginViewController.swift
//  Messenger
//
//  Created by Max Kuznetsov on 03.12.2022.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textAlignment = .center
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Register"
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2, y: 40, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom+10, width: scrollView.width-60, height: 52)
        
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom+10, width: scrollView.width-60, height: 52)
        
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+10, width: scrollView.width-60, height: 52)
        
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom+10, width: scrollView.width-60, height: 52)
        
    }

    @objc private func didTapRegister(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text, let firstName = firstNameField.text, let lastName = lastNameField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else {
            alertUserLoginError(message: "Fill in all fields")
            return
        }
        
        DatabaseManager.shared.userExists(with: email) {[weak self] isExists in
            guard let strongSelf = self else {
                return
            }
            
            guard !isExists else {
                strongSelf.alertUserLoginError(message: "This email is already taken")
                return
            }
            
            print(isExists)
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard error == nil, authResult != nil else {
                    print("Error, try again")
                    print(error?.localizedDescription)
                    return
                }
                
                DatabaseManager.shared.insertUser(user: ChatUser(firstName: firstName, lastName: lastName, emailAddress: email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    private func alertUserLoginError(message: String){
        let alert = UIAlertController(title: "Wooops!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            passwordField.becomeFirstResponder()
        } else if textField == passwordField{
            didTapRegister()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        self.imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
