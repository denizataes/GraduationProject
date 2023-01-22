//
//  NotesViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 18.01.2023.
//

import UIKit

class NotesViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = NoteViewModel()
    var noteList = [NoteVM]()
    var filteredData = [NoteVM]()
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupBindings()
        viewModel.didViewLoad()
        setupUI()
    }
    
    private func setupUI(){
        
        // MARK: NavigationController
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "\("Notlarım".localized()) 📒"
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationItem.searchController = searchController
        
        // MARK: CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.keyboardDismissMode = .onDrag
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        
        //MARK: SearchController
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("İptal".localized(), forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Not başlığına veya oyun adına göre...".localized()
        
        //MARK: NotificationCenter
        NotificationCenter.default.addObserver(forName: NSNotification.Name("noteUpdate"), object: nil, queue: nil){ _ in
            self.viewModel.didViewLoad()
            self.collectionView.reloadData()
        }
        
    }
}

//MARK: UISearchBar Delegate
extension NotesViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = noteList
        
        if !searchText.isEmpty {
            filteredData = noteList.filter({ $0.noteTitle.lowercased().contains(searchText.lowercased()) || $0.gameName.lowercased().contains(searchText.lowercased()) })
        }
        
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        ///if the cancel button is clicked, empty the array, the screen remains blank
        self.activityIndicator.stopAnimating()
        self.filteredData.removeAll()
        self.collectionView.reloadData()
    }
    
}

extension NotesViewController: UICollectionViewDelegateFlowLayout{}

//MARK: UICollectionViewDataSource
extension NotesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let searchBar = searchController.searchBar
        return searchBar.text!.count > 0 ? filteredData.count : noteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destVC = storyboard.instantiateViewController(withIdentifier: "addNoteViewController") as! AddNoteViewController
        let model = filteredData.count > 0 ? filteredData[indexPath.item] : noteList[indexPath.item]
        destVC.id = model.gameID
        destVC.backgroundImage = model.imageBackground
        destVC.gameName = model.gameName
        destVC.descriptionNote = model.noteDescription
        destVC.titleNote = model.noteTitle
        destVC.noteID = model.id.uuidString
        self.present(destVC, animated: true, completion: nil)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Sil".localized(), subtitle: nil, state: .off) { _ in
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
        let searchBar = searchController.searchBar
        let model = searchBar.text!.count > 0 ? filteredData[indexPath.item] : noteList[indexPath.item]
        cell.configure(with: .init(gameTitle: model.gameName, imageBackground: model.imageBackground, createdDate: model.createdDate, noteTitle: model.noteTitle,noteDescription: model.noteDescription))
        return cell
    }
    
}

extension NotesViewController{
    func setupBindings() {
        
        viewModel.onErrorDetected = { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Uyarı".localized(), message: messages, preferredStyle: .alert)
                alertController.addAction(.init(title: "Tamam".localized(), style: .default))
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
            self?.viewModel.showNotification(title:"" ,type: NotificationType.noteDelete)
            NotificationCenter.default.post(name: NSNotification.Name("noteUpdate"), object: nil)
        }
        
    }
}

// MARK: PinterestLayout Delegate
extension NotesViewController : PinterestLayoutDelegate {
    
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
