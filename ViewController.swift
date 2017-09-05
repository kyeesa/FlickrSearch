//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Kye Esa on 10/25/16.
//  Copyright © 2016 Kye Esa. All rights reserved.
//
//this line is for testing reasons uploading to git
import UIKit


// MARK: - Properties
fileprivate let reuseIdentifier = "cell"
fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
var searches = [FlickrSearchResults]()
fileprivate let flickr = Flickr()
fileprivate let itemsPerRow: CGFloat = 1
var selectedImage = UIImage()



class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView1: UICollectionView!
    //@IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blue;
        //let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //collectionViewLayout.minimumLineSpacing = 0
        //collectionViewLayout.minimumInteritemSpacing = 0
    }

    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return searches.count
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //return searches.count
        return searches[section].searchResults.count
    }

    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->UICollectionViewCell
    {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        //2
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.black
        //3
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }
    
   

    
    //THIS IS WHEN AN IMAGE IS SELCTED
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

        let selectedCell = collectionView.cellForItem(at: indexPath) as! FlickrPhotoCell
        selectedImage = selectedCell.imageView.image!
        //collectionView.cellForItem(at: indexPath)
        //collectionView.imageView
        self.performSegue(withIdentifier:"showImage", sender: self)
    }
  
    
    //this stops the orginal view WillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView1.collectionViewLayout.invalidateLayout()
    }
    
    //THIS PREPARES TO OPEN  THE NEW VIEW CONROLLER WITH ID SHOWIMAG
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImage"
        {
            let vc = segue.destination as! NewViewController
            vc.newImage = selectedImage
            //  let vc = postingImage.selectedCell
            //passing data bewtween vioew controllers
        }
    }
    

//END OF CLASS
}






// MARK: - Private
private extension ViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}







//A
extension ViewController: UITextFieldDelegate {
//Do something with the Textfeild(search)

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickrForTerm(textField.text!) {
            results, error in
            
            
            activityIndicator.removeFromSuperview()
            
            
            if let error = error {
                // 2
                print("Error searching : \(error)")
                return
            }
            
            if let results = results {
                // 3
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                searches.insert(results, at: 0)
                
                // 4
               self.collectionView1.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }

    
    
}











//Do something with the data recieved
    //1
//     func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return searches.count
//    }
    
    //2


    



//C
extension ViewController : UICollectionViewDelegateFlowLayout {
//how to set out the layout

    //1
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     //2
         let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
         let availableWidth = view.frame.width - paddingSpace
         let widthPerItem = availableWidth / itemsPerRow
         
         return CGSize(width: widthPerItem, height: 150)
     }
    
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }


}













