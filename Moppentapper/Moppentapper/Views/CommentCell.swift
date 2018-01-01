//
//  CommentCell.swift
//  Moppentapper
//
//  Created by Stijn De Backer on 01/01/2018.
//  Copyright © 2018 Stijn De Backer. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {

    @IBOutlet weak var inhoudLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var inhoudheightconstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 8)
        
        
    }
    
    var comment: Comment! {
        didSet {
            usernameLabel.text = comment.auteur.username
            inhoudLabel.text = comment.inhoud
            prepareView()
        }
    }
    
    func prepareView(){
        layer.cornerRadius = 8
        layer.borderWidth = 1
        
        let size = CGSize(width: widthConstraint.constant, height: 1000)
        
        //let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        //let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        let estimatedFrame = NSString(string: comment.inhoud).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        //let test = NSString(string: post.inhoud).boundingRect(with: <#T##CGSize#>, options: <#T##NSStringDrawingOptions#>, attributes: <#T##[NSAttributedStringKey : Any]?#>, context: <#T##NSStringDrawingContext?#>)
        
        inhoudheightconstraint.constant = estimatedFrame.height + 75
        
        
        
    }

}
