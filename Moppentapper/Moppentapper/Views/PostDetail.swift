//
//  PostDetail.swift
//  Moppentapper
//
//  Created by Stijn De Backer on 06/01/2018.
//  Copyright © 2018 Stijn De Backer. All rights reserved.
//

import UIKit
import Cosmos

class PostDetail: UICollectionViewCell {

    
    
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var postDetailViewController: PostDetailViewController! {
        didSet{
            print("cuwl")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 8)
        
        
    }
    
    var post: Post! {
        didSet {
            prepareView()
        }
    }
    
    func prepareView(){
        
        //rating + buttons instellen
        rating.rating = Double(post.score())
        if !(isKeyPresentInUserDefaults(key: "username")){
            rateButton.isEnabled = false
            rating.settings.updateOnTouch = false
            //comment unable
            addCommentButton.isEnabled = false
            commentField.isEnabled = false
        }
        
        
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @IBAction func Rate(_ sender: Any) {
        print(rating.rating)
        let punten = Rating(auteur: UserDefaults.standard.string(forKey: "username")!, post: post.id, beoordeling: Int(rating.rating), datum: Date())
        
        KituraService.shared.ratePost(beoordeling: punten){
            if let post = $0 {
                self.post = post
                
                self.postDetailViewController.reload(post: post)
            }
        }
    }
    
    @IBAction func AddComment(_ sender: Any) {
        
        if (commentField.text == "") {
            return
        }
        
        let user = User(name: "", email: UserDefaults.standard.string(forKey: "email")!, username: UserDefaults.standard.string(forKey: "username")!, password: "")
        
        let comment = Comment(inhoud: commentField.text!, user: UserDefaults.standard.string(forKey: "username")!, post: post.id, beoordeling: 0, datum: Date())
        
        KituraService.shared.addComment(comment: comment){
            if let post = $0 {
                self.post = post
                self.postDetailViewController.reload(post:post)
            }
        }
    }
    
    

}
