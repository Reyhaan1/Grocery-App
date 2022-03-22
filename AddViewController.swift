//
//  AddViewController.swift
//  GroceryApp
//
//  Created by Reyhaan Alim on 21/03/2022.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderWidth = CGFloat(1)
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = CGFloat(7)
        descriptionTextView.text = "Enter Description..."
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        
        titleTextField.layer.borderWidth = CGFloat(1)
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.cornerRadius = CGFloat(5)
        titleTextField.placeholder = "Enter Title..."

    }
    
    @IBAction func addButtonDidTouch(_ sender: Any) {
        let groceryTitle = titleTextField.text ?? ""
        let groceryDescription = descriptionTextView.text ?? ""
        delegate?.addNewGrocery(title: groceryTitle, description: groceryDescription)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if  textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
