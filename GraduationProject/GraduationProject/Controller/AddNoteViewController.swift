//
//  AddNoteViewController.swift
//  GraduationProject
//
//  Created by Deniz Ata Eş on 18.01.2023.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteDescription: IQTextView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    var viewModel = AddNoteViewModel()
    var gameViewModel = GameDetailViewModel()
    
    var id: String = ""
    var gameName: String = ""
    var backgroundImage: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    private func setupUI(){
        self.imageView.kf.setImage(with: URL(string: backgroundImage))
        self.nameLabel.text = gameName
        noteDescription.layer.cornerRadius = 16
        imageView.layer.cornerRadius = 16
        imageView.layer.shadowRadius = 16
        
    }

    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if onSaveNotes(){
            viewModel.saveNote(vm: .init(id: UUID(), gameID: id, gameName: gameName , noteTitle: noteTitle.text ?? "", noteDescription: noteDescription.text ?? "", imageBackground: backgroundImage, createdDate: Utils.shared.getDate()))

        }
    }
    
    private func onSaveNotes() -> Bool{
        var result: Bool = true
        if noteTitle.text == "" {
            let alertController = UIAlertController(title: "\("Uyarı".localized()) ⚠️", message: "Not başlığı boş bırakılamaz!".localized(), preferredStyle: .alert)
            alertController.addAction(.init(title: NSLocalizedString("Tamam", comment: ""), style: .default))
            self.present(alertController, animated: true, completion: nil)
            result = false
        }
        else if noteDescription.text == ""{
            let alertController = UIAlertController(title: "\("Uyarı".localized()) ⚠️", message: "Not açıklaması boş bırakılamaz!".localized(), preferredStyle: .alert)
            alertController.addAction(.init(title: "Tamam".localized(), style: .default))
            self.present(alertController, animated: true, completion: nil)
            result = false
        }
        return result
    }
    
    @IBAction func backBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

//MARK: Bindings
extension AddNoteViewController{
    func setupBindings() {
        viewModel.didNoteSave = { [weak self] in
            self?.gameViewModel.showNotification(title: self?.nameLabel.text ?? "", type: NotificationType.noteAdd)
            NotificationCenter.default.post(name: NSNotification.Name("noteUpdate"), object: nil)
            self?.dismiss(animated: true)
        }
    }
}

