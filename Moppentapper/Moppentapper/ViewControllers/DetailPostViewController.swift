import Cosmos
import Foundation
import UIKit

class DetailPostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var PostCollectionView: UICollectionView!
    @IBOutlet weak var postHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var comments: UICollectionView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KituraService.shared.getDetailPost(withId: post.id) {
            if let post = $0 {
                self.post = post
                self.PostCollectionView.reloadData()
                self.comments.reloadData()
            }
        }
        //postCell
        PostCollectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = PostCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        PostCollectionView.dataSource = self
        //CommentCell
        comments.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        if let flowLayout = comments.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        comments.dataSource = self
        //postHeightConstraint instellen
        let size = CGSize(width: 400, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let estimatedFrame = NSString(string: post.inhoud).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        postHeightConstraint.constant = estimatedFrame.height + 200
        
        //rating + buttons instellen
        rating.rating = Double(post.score())
        if !(isKeyPresentInUserDefaults(key: "username")){
            rateButton.isEnabled = false
            rating.settings.updateOnTouch = false
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Rate(_ sender: Any) {
        print(rating.rating)
        let punten = Rating(auteur: UserDefaults.standard.string(forKey: "username")!, post: post.id, beoordeling: Int(rating.rating), datum: Date())
        
        KituraService.shared.ratePost(beoordeling: punten){
            if let post = $0 {
                self.post = post
                self.PostCollectionView.reloadData()
                self.comments.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.comments {return post.comments.count}
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.comments {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.comment = post.comments[indexPath.item]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.post = post
            return cell
        }
    }
}

