//
//  UserProfileViewController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 20/02/2022.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let userModel: UserModel
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = UIColor.black
        tf.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14)]
        )
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.text = userModel.email
        return tf
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Display Name",
            attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14)]
        )
        tf.text = userModel.username
        return tf
    }()
    
    
    lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.attributedPlaceholder = NSAttributedString(
            string: "What I Do",
            attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14)]
        )
        return tf
    }()
    
    lazy var phoneTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Phone Number - (123) 555-5555",
            attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14)]
        )
        return tf
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2539359629, green: 0.3838947415, blue: 0.9965317845, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        return button
    }()
    
    init(userModel: UserModel) {
        self.userModel = userModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: 140, height: 140), padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInputFields()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleUpdate() {
        self.saveUserDocuments()
    }
    
    fileprivate func saveUserDocuments() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let username = usernameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        
        let db = Firestore.firestore()
        let document: [String: Any] = ["username": username, "email": email, "number": phoneTextField.text ?? "","title": titleTextField.text ?? "", "uid": userId]
        db.collection("users").document(userId).setData(document) { err in
            if err != nil {
                return
            }
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setUpVc()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField,
                                                       self.usernameTextField,
                                                       self.titleTextField,
                                                       self.phoneTextField,
                                                       self.updateButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 50
        view.addSubview(stackView)
        
        stackView.anchor(top: self.plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 400), padding: .init(top: 20, left: 40, bottom: 0, right: 40))
    }
    
}
