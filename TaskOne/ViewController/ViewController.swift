//
//  ViewController.swift
//  TaskOne
//
//  Created by Zulqarnain on 19/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // Mark: - Outlets
    
    @IBOutlet weak var transferImageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Mark: - Properties
    
    private var hostService = HostService()
    var imagesUrlArray: [Images]? = nil
    let httpResource: ImageResource = ImageResource()
    var progressValues: Float = 0.0
    var socket: GCDAsyncSocket?
    var isHost = false
    var imagesURL:[String] = []
    
    // Mark: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProgressBar), name: Notification.Name("NotificationIdentifier"), object: nil)
        startBroadcast()
        // Do any additional setup after loading the view.
    }
    
    // Mark: - Custom Method
    @objc func updateProgressBar(){
        
        progressValues += 0.33
        print("progressValues  : \(progressValues)")
        if progressValues == 0.99{
            progressValues = progressValues + 0.01
            DispatchQueue.main.async {
            self.transferImageButton.isHidden = false
            }
        }
        DispatchQueue.main.async {
            self.progressBar.progress = self.progressValues
        }
    }
    
    func startBroadcast() {
        hostService.startBroadcast(netServiceBlock: { (isConnected, netServiceStatus) in
            if isConnected {
                print("NetSrvice Connected.")
            } else {
                print("NetService Failed to connect.")
            }
        }, socketBlock: { (socketStatus, objSocket) in
            self.socket(status: socketStatus, socket: objSocket)
        }) { (incomingVal) in
            //self.incomingValue(str: incomingVal)
        }
    }
    
    // Mark: - Action Method
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        httpResource.fetchImages { (_imagesResponse) in

                    if(_imagesResponse?.images != nil)
                    {
                        self.imagesUrlArray = _imagesResponse?.images
                        self.imagesUrlArray = Array((self.imagesUrlArray?[0...2])!)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
    }
    
    @IBAction func transferImagesButtonPressed(_ sender: Any) {
        self.imagesURL.forEach({ URL in
            print("Appended URL is \(URL)")
            sendValue(str: URL)
        })
    }
    
}

// Mark: - ViewController extension for Collection View Methods

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imagesUrlArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        let image = self.imagesUrlArray?[indexPath.row]
        if let ImageUrl = URL(string: image?.image ?? "https://www.ccarprice.com/products/Tesla_Model_S_Performance_2021.jpg"){
            self.imagesURL.append(image?.image ?? "https://www.ccarprice.com/products/Tesla_Model_S_Performance_2021.jpg")
        cell.displayedImage.loadImage(fromURL: ImageUrl)
        }
        return cell
    }
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 160)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// Mark: - ViewController extension for getting socket object from broadcasting.
extension ViewController{
    func socket(status: String, socket: GCDAsyncSocket) {
            self.socket = socket
            self.pushToGameView(objSock: socket)
    }
    func pushToGameView(objSock: GCDAsyncSocket) {
        isHost = true
        self.socket = objSock
    }

    func sendValue(str: String) {
        let data = Data(str.utf8)
        socket?.write(data, withTimeout: 30.0, tag: isHost ? 2 : 3)
        socket?.readData(toLength: 1024*10, withTimeout: 30.0, tag:  isHost ? 2 : 3)
    }
}
