//
//  File.swift
//  Tinder App
//
//  Created by Kingsley Charles on 27/03/2021.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseFirestore
import FirebaseAuth

class RegistrationViewModel {
    typealias completion = ((Error)?) -> ()
    private let isCorrectlyFilled = PublishSubject<Bool>()
    var correctEntry: Observable<Bool> {
        return isCorrectlyFilled.asObservable()
    }
    let hasRegistered = PublishSubject<Bool>()
    var registrationObserver: Observable<Bool> {
        return hasRegistered.asObservable()
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
    
    var username: UserDetailsField? {
        didSet{
            handleKeyboardInput()
        }
    }
    
    
    func handleKeyboardInput() {
        let isEmpty = (email?.text?.isEmpty ?? true || password?.text?.isEmpty ?? true || username?.text?.isEmpty ?? true)
        let isCompleted = !isEmpty
        
        _ = isCompleted ? isCorrectlyFilled.onNext(true) : isCorrectlyFilled.onNext(false)
    }
    
    func registerUser(completion: @escaping ((Error)?) -> ()) {
        guard let email = email?.text , let password = password?.text else {return}
        self.hasRegistered.onNext(false)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
    
            if let error = error {
                completion(error)
                self.hasRegistered.onNext(false)
                return
            }
            self.hasRegistered.onNext(true)
            completion(nil)
        }
        
    }
}

