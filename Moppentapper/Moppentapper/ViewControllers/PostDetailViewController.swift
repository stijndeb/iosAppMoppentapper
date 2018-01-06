import Cosmos
import UIKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var postDetailCollectionView: UICollectionView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KituraService.shared.getDetailPost(withId: post.id) {
            if let post = $0 {
                self.post = post
                self.postDetailCollectionView.reloadData()
                //self.comments.reloadData()
            }
        }
        //postCell
        postDetailCollectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = postDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        postDetailCollectionView.dataSource = self
        //CommentCell
        postDetailCollectionView.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        if let flowLayout = postDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        postDetailCollectionView.dataSource = self
        
        
        postDetailCollectionView.register(UINib.init(nibName: "PostDetail", bundle: nil), forCellWithReuseIdentifier: "PostDetail")
        if let flowLayout = postDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        
        
        
        //postHeightConstraint instellen
        let size = CGSize(width: 400, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let estimatedFrame = NSString(string: post.inhoud).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        //postHeightConstraint.constant = estimatedFrame.height + 200
        
        
        //rating + buttons instellen
        /*rating.rating = Double(post.score())
        if !(isKeyPresentInUserDefaults(key: "username")){
            rateButton.isEnabled = false
            rating.settings.updateOnTouch = false
        }*/
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
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
    }*/
    
    func reload(post: Post){
        self.post = post
        self.postDetailCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return post.comments.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.post = post
            return cell
        }else if (indexPath.item == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostDetail", for: indexPath) as! PostDetail
            cell.postDetailViewController = self
            cell.post = post
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
            cell.comment = post.comments[indexPath.item-2]
            return cell
        }
    }
}

/*
extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewHeight = self.topView.frame.size.height + 2
        let offset = min(scrollView.contentOffset.y, viewHeight)
        
        if offset >= 0 || self.topViewConstraint.constant != 0 {
            self.topViewConstraint.constant = -offset

            let percent = max(1 - offset/viewHeight,0)
            self.topView.alpha = percent
            print("done")
        }
    }
}*/
