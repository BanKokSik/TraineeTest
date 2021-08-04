//
//  ImageCollectionViewController.swift
//  TraineeTest
//
//  Created by Nikita Chekmarev on 27.07.2021.
//

import UIKit
import Kingfisher
import Alamofire


class ImageCollectionViewController: UICollectionViewController {


    private var loadedFlag = false
    private var page = 1
    private var refreshControl = UIRefreshControl()
    private var bottomRefresh = UIActivityIndicatorView()
    private var totalPage = 1
    private var isLoading = false
    private var isNewOrPop = true
    
    private var imageModel: ImageModel?
    private var photos: [DataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        isNewOrPop = self.collectionView.tag == 0
        DispatchQueue.main.async {
            self.loadData(page: self.page)
        }
    }

    override func viewWillTransition (to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
    
    private func setCollectionView(){
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        collectionView.register(ReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ReusableView")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        collectionView.refreshControl = refreshControl
    }
    
    
    
    @objc func refreshData() {
        collectionView.refreshControl?.beginRefreshing()
        page = 1
        loadedFlag = false
        photos.removeAll()
        DispatchQueue.main.async {
            self.loadData(page: self.page)
        }
        collectionView.refreshControl?.endRefreshing()
    }
    private func loadData(page: Int) {
        self.isLoading = true
        
        LoadData.shared.loadPhotos(page:page, newOrPop: isNewOrPop ,result: {[weak self] (model) in
            if model != nil{
                self?.imageModel = model
                self?.loadedFlag = true
                self?.photos.append(contentsOf: (model?.data)!)
                self?.totalPage = model?.countOfPages ?? 1
                self?.isLoading = false
                self?.collectionView.reloadData()
            } else {
                self?.photos.removeAll()
                self?.loadedFlag = false
                self?.isLoading = false
            }
        })
    }
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
        if loadedFlag{
            guard let imageName = photos[indexPath.row].image?.name
            else {
                return UICollectionViewCell()
            }
            DispatchQueue.main.async {
                cell.imageView.kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: URL(string: "http://gallery.dev.webant.ru/media/\(imageName)")!, cacheKey: "http://gallery.dev.webant.ru/media/\(imageName)")
                cell.imageView.kf.setImage(with: resource)
                cell.imageView.contentMode = .scaleAspectFill
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            if isLoading {
                let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableView", for: indexPath)
                reusable.addSubview(bottomRefresh)
                bottomRefresh.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
                return reusable
            } else {
                let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableView", for: indexPath)
                return reusable
            }
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoading {
            if indexPath.row == photos.count - 1 && page < totalPage {
                page += 1
                loadedFlag = false
                bottomRefresh.startAnimating()
                DispatchQueue.main.async {
                    self.loadData(page: self.page)
                }
            }
        }
        if page == totalPage {
            bottomRefresh.stopAnimating()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DeteilController", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeteilController" {
            if let detailController = segue.destination as? DetailViewController,
               let row = (sender as? NSIndexPath)?.row {
                if self.photos.count >= row+1 {
                    guard let imageName = self.photos[row].image?.name
                    else {
                        return
                    }
                    let inputData = DetailImageModel(imageRequest: "http://gallery.dev.webant.ru/media/\(imageName)", titleLabelText: self.photos[row].name, textLabelText: self.photos[row].desc)
                    detailController.setupDataInController(inputData: inputData)
                } else {
                    let inputData = DetailImageModel(titleLabelText: "", textLabelText: "No internet connection")
                    detailController.setupDataInController(inputData: inputData)
                }
            }
        }
    }
}



extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat?
        if UIApplication.shared.statusBarOrientation.isPortrait {
            width =  (self.view.frame.size.width - 16*3) / 2
        }else {
            width =  (self.view.frame.size.width - 16*4) / 4
        }
        let size = CGSize(width: width! , height: (width!) * 13 / 17)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)->UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8)
    }
}
