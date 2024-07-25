//
//  ViewController.swift
//  Project10
//
//  Created by Hyeongchae Son on 7/24/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // need to use guard let because it has to be cast to the PersonCell type
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let ac = UIAlertController(title: "Add New Person", message: "Choose where to get the image", preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.showsCameraControls = true
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        
        ac.addAction(photoLibraryAction)
        ac.addAction(cameraAction)
        
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        print("(in main) 추가된 사람:", people[0].name)
        collectionView.reloadData()

        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        print("thisis check for person", person.name, person.image)
        let ac = UIAlertController(title: "Do you want to delete or rename this person", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Enter new name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self?.present(ac, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(deleteAction)
        ac.addAction(renameAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
}

