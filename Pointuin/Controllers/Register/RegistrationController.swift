//
//  registrationController.swift
//  Tinder App
//
//  Created by Kingsley Charles on 26/03/2021.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import Foundation


class RegistrationController: UIViewController {
    let registrationModel = RegistrationViewModel()
    let imageContainer = PublishSubject<UIImage>()
    let disposeBag = DisposeBag()
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registering"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.1)
        return hud
    }()
    
    
    var gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [#colorLiteral(red: 0.6085609794, green: 0.8245826364, blue: 1, alpha: 1).cgColor , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor]
        gradient.locations = [0 , 1]
        return gradient
    }()
    
    lazy var estimateProfileView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let image = #imageLiteral(resourceName: "pointuinuse_icon")
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return imageView
    }()
    
    lazy var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        let image = #imageLiteral(resourceName: "pointuinuse_logo")
        imageView.image = image
        return imageView
    }()
    
    lazy var emailTextField: UserDetailsField = {
        let txt = UserDetailsField()
        let placeholder = "Enter Email"
        txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        txt.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return txt
    }()
    
    lazy var usernameTextField: UserDetailsField = {
        let txt = UserDetailsField()
        let placeholder = "Enter Username"
        txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        txt.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return txt
    }()
    
    lazy var passwordTextField: UserDetailsField = {
        let txt = UserDetailsField()
        let placeholder = "Enter Password"
        txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        txt.isSecureTextEntry = true
        txt.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return txt
    }()
    
    lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 25
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.isEnabled = false
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .black)
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        return btn
    }()
    
    lazy var signInNavigation: UIButton = {
        let btn = UIButton()
        btn.setTitle("Have an Account? Log in", for: .normal)
        btn.addTarget(self, action: #selector(userLoginHandler), for: .touchUpInside)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setGradientBackground()
        setUpView()
        keyboardDismissGesture()
        handleKeyBoardObserver()
    }
    
    @objc fileprivate func registerUser() {
        self.view.endEditing(true)
        hud.show(in: self.view)
        registrationModel.registerUser { err in
            if let err = err {
                self.hud.textLabel.text = "Error Registering"
                self.hud.detailTextLabel.text = err.localizedDescription
                self.hud.dismiss(afterDelay: 2, animated: true)
                return
            }
            
            let userModel = UserModel(username: self.usernameTextField.text!, email: self.emailTextField.text!)
            self.navigationController?.pushViewController(UserProfileController(userModel: userModel)
                                                         , animated: true)
            
        }
    }
    
    @objc fileprivate func userLoginHandler() {
        navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    fileprivate func handleKeyBoardObserver() {
        _ = registrationModel.correctEntry.subscribe(onNext: { [weak self] authorised in
            if authorised == true {
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.2539359629, green: 0.3838947415, blue: 0.9965317845, alpha: 1)
                self?.registerButton.isEnabled = true
            } else {
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                self?.registerButton.isEnabled = false
            }
        })
        _ = registrationModel.registrationObserver.subscribe(onNext: { [weak self] hasRegistered in
            if hasRegistered == true {
                self?.hud.dismiss()
            }
            else {
                self?.hud.show(in: self!.view)
            }
        })
    }
    
    @objc fileprivate func handleTextChanged(textfield: UserDetailsField) {
        if textfield == passwordTextField {
            registrationModel.password = textfield
        }
        if textfield == usernameTextField {
            registrationModel.username = textfield
            
        }
        if textfield == emailTextField {
            registrationModel.email = textfield
        }
    }
    
    fileprivate func keyboardDismissGesture() {
        let swipeGesture = UISwipeGestureRecognizer (target: self, action: #selector(hideKeyboard))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewWillLayoutSubviews() {
        gradient.frame = view.bounds
    }
    
    func setGradientBackground() {
        view.layer.addSublayer(gradient)
    }
    
    fileprivate func setUpView() {
        let stackView = UIStackView(arrangedSubviews: [estimateProfileView,emailTextField,usernameTextField,
                                                       passwordTextField, registerButton])
        self.view.addSubview(self.logoView)
        
        view.addSubview(stackView)
        view.addSubview(signInNavigation)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInNavigation.anchor(top: nil, leading: nil, trailing: nil, bottom: view.bottomAnchor,size: CGSize(width: 200, height: 100),padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        signInNavigation.centerXAnchor.constraint(equalTo: view.centerXAnchor) .isActive = true
        
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.anchor(top: nil, leading: nil, trailing: nil, bottom: stackView.topAnchor, size: CGSize(width: 115, height: 115), padding: UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0))
        
       
        
    }
}
