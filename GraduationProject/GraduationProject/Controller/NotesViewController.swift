//
//  NotesViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 18.01.2023.
//

import UIKit

class NotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = NoteViewModel()
    var noteList = [NoteVM]()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupBindings()
        viewModel.didViewLoad()
        setupUI()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("noteUpdate"), object: nil, queue: nil) { _ in
            self.viewModel.didViewLoad()
            self.collectionView.reloadData()
        }
        
    }
    private func setupUI(){
        
        // MARK: NavigationController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "Notlarım 📒"
        
        // MARK: CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
}

extension NotesViewController: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//
//        let collectionViewSize = collectionView.frame.size.width
//        return CGSize(width: collectionViewSize/2.2, height: 200)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
//        }
}

extension NotesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteList.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Sil", subtitle: nil, state: .off) { _ in
                    let model = self?.noteList[indexPath.item]
                    guard ((model?.id) != nil) else {return}
                    self?.viewModel.deleteNotes(id: model!.id)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCollectionViewCell
        let model = noteList[indexPath.item]
        cell.configure(with: .init(gameTitle: model.gameName, imageBackground: model.imageBackground, createdDate: model.createdDate, noteTitle: model.noteTitle,noteDescription: model.noteDescription))
        return cell
    }
}

extension NotesViewController{
    func setupBindings() {
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Alert", message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Ok", style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }

        
        viewModel.noteList = { [weak self] notes in
            DispatchQueue.main.async {
                self?.noteList = notes
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.didNoteDeleted = {[weak self] in
            NotificationCenter.default.post(name: NSNotification.Name("noteUpdate"), object: nil)
        }
    }
}

extension NotesViewController : PinterestLayoutDelegate {
    // MARK: implemented PinterestLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        return 250
    }

    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
            let note = noteList[indexPath.item]
            let captionFont = UIFont.systemFont(ofSize: 10)
            let captionHeight = Utils.shared.height(for: note.noteDescription, with: captionFont, width: width)
            return captionHeight-48
    }
}
