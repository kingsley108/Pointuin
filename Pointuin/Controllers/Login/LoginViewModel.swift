//
//  LoginModel.swift
//  Tinder App
//
//  Created by Kingsley Charles on 24/04/2021.
//


import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class LoginViewModel {
    let isCorrectlyFilled = PublishSubject<Bool>()
    var validEntry: Observable<Bool> {
        return isCorrectlyFilled.asObservable()
    }
    let hasLoggedIn = PublishSubject<Bool>()
    var loginObserver: Observable<Bool> {
        return hasLoggedIn.asObservable()
    }
    
    var email: UserDetailsField?  {
        didSet{
            handleKeyboardInput()
        }
    }
    
    var password: UserDetailsField? {
        didSet{
            handleKeyboardInput()
        }
    }
    
    func handleKeyboardInput() {
        let isEmpty = (email?.text?.isEmpty ?? true || password?.text?.isEmpty ?? true)
        let isCompleted = !isEmpty
        
        _ = isCompleted ? isCorrectlyFilled.onNext(true) : isCorrectlyFilled.onNext(false)
    }
    
    func signInUsers(completion: @escaping ((Error)?) -> ()) {
        guard let email = email?.text , let password = password?.text else {return}
        self.hasLoggedIn.onNext(false)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                completion(error)
                strongSelf.hasLoggedIn.onNext(false)
                return
            }
            self?.hasLoggedIn.onNext(true)
            completion(nil)
        }
        
    }
    
}
