//
//  FIRDatabase.swift
//  Tinder App
//
//  Created by Kingsley Charles on 15/05/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

extension Firestore {
    func fetchCurrentUser(uid: String,completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else {
                let error = NSError(domain: "com.lbta.swipematch", code: 500, userInfo: [NSLocalizedDescriptionKey: "No user found in Firestore"])
                completion(nil, error)
                return
            }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user, nil)
        }
    }
}
