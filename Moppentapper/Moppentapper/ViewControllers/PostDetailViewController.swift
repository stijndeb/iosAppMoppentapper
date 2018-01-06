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
        
        
        
        
    }

    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
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


