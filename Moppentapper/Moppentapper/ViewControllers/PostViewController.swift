import UIKit

class PostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        KituraService.shared.getPosts {
            if let posts = $0 {
                self.posts = posts
                print(posts)
                self.collectionView.reloadData()
            }
        }
        
        collectionView.register(UINib.init(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: "PostCell")
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        collectionView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("oh")
        switch segue.identifier {
        case "showPost"?:
            print("niet")
            let postDetailViewController = segue.destination as! PostDetailViewController
            let selection = collectionView.indexPathsForSelectedItems!.first!
            postDetailViewController.post = posts[selection.item]
        default:
            fatalError("Unknown segue")
        }
    }
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return posts.count
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as! PostCell
        
        
        
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        //let postDetailViewController = segue.destination as! PostDetailViewController
        //let selection = collectionView.indexPathsForSelectedItems!.first!
        //postDetailViewController.post = posts[selection.item]
        let postDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        
        postDetailViewController.post = posts[indexPath.item]
        
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
        
    }
    
    /*func collectionView(_ collectionViw: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            headerView.backgroundColor = UIColor.brown
        }
        return headerView
    }*/
}
