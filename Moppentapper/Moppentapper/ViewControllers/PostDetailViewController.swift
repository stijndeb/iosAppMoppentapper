

import UIKit

class PostDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var commnets: UICollectionView!
    
    @IBOutlet weak var postHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var PostCollectionView: UICollectionView!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //haal comments etc op
        KituraService.shared.getDetailPost(withId: post.id) {
            if let post = $0 {
                self.post = post
                self.PostCollectionView.reloadData()
                self.commnets.reloadData()
            }
        }
        PostCollectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = PostCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        PostCollectionView.dataSource = self
        
        commnets.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellWithReuseIdentifier: "CommentCell")
        if let flowLayout = commnets.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        commnets.dataSource = self
        
        
        let size = CGSize(width: 400, height: 1000)
        
        //let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        //let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        let estimatedFrame = NSString(string: post.inhoud).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        //let test = NSString(string: post.inhoud).boundingRect(with: <#T##CGSize#>, options: <#T##NSStringDrawingOptions#>, attributes: <#T##[NSAttributedStringKey : Any]?#>, context: <#T##NSStringDrawingContext?#>)
        
        postHeightConstraint.constant = estimatedFrame.height + 200
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.commnets {return post.comments.count}
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.commnets {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        
        
        cell.comment = post.comments[indexPath.item]
        return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
            cell.post = post
            return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
