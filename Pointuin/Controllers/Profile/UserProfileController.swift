//
//  UserProfileViewController.swift
//  Pointuin
//
//  Created by Kingsley Charles on 20/02/2022.
//

import UIKit
import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import JGProgressHUD

class UserProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate let userModel: UserProfile?
    fileprivate let dataArray = ["Scrum Master", "Developer", "Non Developer"]
    fileprivate var user: User? {
        didSet {
            guard let user = self.user else {return}
            self.emailTextField.text = user.email
            self.usernameTextField.text = user.username
            self.titleTextField.text = user.title
            self.phoneTextField.text = user.number
            guard let index = dataArray.firstIndex(where: {$0 == user.acessLevel}) else {return}
            self.pickerView.selectRow(index, inComponent: 0, animated: true)

            EstimationProfileImageView.loadImage(urlString: user.profileImageUrl) { image in
                
                DispatchQueue.main.async {
                   let image = image
                    self.plusPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                }
                
            }
        }
    }
    
    lazy var pickerView: UIPickerView = {
        let picker: UIPickerView = UIPickerView()
        
        return picker
    }()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 70
        button.layer.masksToBounds = true
//        button.tintColor = .clear
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
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
        tf.text = userModel?.email
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
        tf.text = userModel?.username
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
        button.backgroundColor = .homeColour
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        return button
    }()
    
    init(userModel: UserProfile) {
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
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, size: CGSize(width: 140, height: 140), padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.hud.show(in: self.view)
        self.setupProfileDetails()
        self.layoutInputFields()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
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
    
    fileprivate func setupProfileDetails() {
        
        if self.userModel == nil {
            
            guard let uId = Auth.auth().currentUser?.uid else {return}
            
            Firestore.firestore().getUserUpdates(uid: uId) { (user, err) in
                
                if let err = err {
                    print("Failed to fetch user:", err)
                    self.hud.dismiss(afterDelay: 0.2, animated: true)
                    return
                }
                
                self.user = user
                self.hud.dismiss(afterDelay: 0.5, animated: true)
            }
        }
        
        self.hud.dismiss(animated: true)
        
    }
    
    
    
    
    
    fileprivate func saveUserDocuments() {
        
        guard let image = self.plusPhotoButton.imageView?.image else { return }
        guard let userId = Auth.auth().currentUser?.uid else {return}
        guard let username = usernameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        let db = Firestore.firestore()
        
        
        let acessLevel =  self.dataArray[self.pickerView.selectedRow(inComponent: 0)]
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
            
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            // Firebase 5 Update: Must now retrieve downloadURL
            storageRef.downloadURL(completion: { [self] (downloadURL, err) in
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                
                let document: [String: Any] = ["username": username, "email": email, "number": phoneTextField.text ?? "","title": self.titleTextField.text ?? "","acess": acessLevel  ,"uid": userId, "profileImageUrl": profileImageUrl]
                db.collection("users").document(userId).setData(document) { err in
                    if err != nil {
                        return
                    }
                    
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setUpVc()
                    self.dismiss(animated: true, completion: nil)
                    
                }
            })

        })
    }
    
    
    fileprivate func layoutInputFields() {
        let stackView = UIStackView(arrangedSubviews: [self.emailTextField,
                                                       self.usernameTextField,
                                                       self.titleTextField,
                                                       self.phoneTextField,
                                                       self.pickerView,
                                                       self.updateButton
                                                      ])
        self.setupPickerView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 50
        view.addSubview(stackView)
        
        stackView.anchor(top: self.plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: self.view.trailingAnchor, bottom: nil, size: CGSize(width: 0, height: 490), padding: .init(top: 20, left: 40, bottom: 0, right: 40))
    }
    
}

extension UserProfileController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    fileprivate func setupPickerView() {
        
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.dataSource = self as UIPickerViewDataSource
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = self.dataArray[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text =  self.dataArray[row]
        label.textAlignment = .center
        return label
    }
}
