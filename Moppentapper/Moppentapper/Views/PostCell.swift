
import UIKit

class PostCell: UICollectionViewCell {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var inhoudLabel: UILabel!
    @IBOutlet weak var inhoudHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        print(widthConstraint.constant)
        print(screenWidth)
        widthConstraint.constant = screenWidth - (2 * 8)
        
        
    }
    
    var post: Post! {
        didSet {
            titleLabel.text = post.title
            inhoudLabel.text = post.inhoud
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
        
        let estimatedFrame = NSString(string: post.inhoud).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        //let test = NSString(string: post.inhoud).boundingRect(with: <#T##CGSize#>, options: <#T##NSStringDrawingOptions#>, attributes: <#T##[NSAttributedStringKey : Any]?#>, context: <#T##NSStringDrawingContext?#>)
        
        inhoudHeightConstraint.constant = estimatedFrame.height + 75
        
        
        
    }

}
