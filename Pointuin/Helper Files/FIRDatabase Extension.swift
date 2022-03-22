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
    
    static var userHasMatched: Bool = false
    
    func saveSwipesToFirestore(swipedUserId: String, for val: Int) -> Completable {
        
        return Completable.create { (observer) -> Disposable in
            guard let userID = Auth.auth().currentUser?.uid else {
                return Disposables.create()
            }
            self.collection("swipes").document(userID).getDocument { (snapshot, err) in
                if let err = err {
                    //Do something
                    print(err)
                }
                
                if let data = snapshot?.data() {
                    //then there is existing data
                    self.updateData(with: userID, forUser: swipedUserId, for: val)
                    
                } else {
                    self.setData(with: userID, forUser: swipedUserId, for: val)
                }
                
                self.checkForMatch(for: userID, matchedUser: swipedUserId) { matchStatus in
                    if matchStatus == true {
                        print("done")
                        observer(.completed)
                    }
                    else {
                        print("failure")
                        observer(.error(Errors.couldNotMatch))
                    }
                }
            }
            return Disposables.create()
        }
        
        
    }
    
    fileprivate func updateData(with user: String, forUser swipeableUser: String, for val: Int) {
        
        let data: [String: Any] = [swipeableUser: val]
        self.collection("swipes").document(user).updateData(data) { (err) in
            if let err = err {
                print(err)
            }
        }
    }
    
    fileprivate func setData(with user: String, forUser swipeableUser: String, for val: Int) {
        let data: [String: Any] = [swipeableUser: val]
        self.collection("swipes").document(user).setData(data) { (err) in
            if let err = err {
                print(err)
            }
        }
    }
    
    fileprivate func checkForMatch(for user: String, matchedUser: String, completion: @escaping ((Bool) -> ())) {
        
        self.collection("swipes").document(matchedUser).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                completion(false)
                return
            }
            
            guard let data = snapshot?.data() as? [String: Int] else {return}
            if data[user] == 1 {
                
                completion(true)
                
            }
            
        }
    }
}
