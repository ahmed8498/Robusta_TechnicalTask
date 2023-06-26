//
//  UIViewControllerExtension.swift
//  Robusta_TechnicalTask
//
//  Created by Ahmed Mohamed on 26/06/2023.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(error: CustomError) {
        let alert: UIAlertController = UIAlertController(title: "", message: error.message(), preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
