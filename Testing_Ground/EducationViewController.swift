//
//  EducationViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/10/23.
//

import Foundation
import UIKit

class EducationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonTitles = [
            "What is Eosinophilic Esophagitis (EOE)?",
            "How is it Diagnosed?",
            "How is it Treated?",
            "Who is Affected?",
            "What are Symptoms?",
            "What Causes EOE?",
            "Where Can I Find More Information?"
        ]

        var previousButton: UIButton?
        let headerHeight: CGFloat = 100
        let spacing: CGFloat = 24 

        for title in buttonTitles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(
                red: 138.0/255.0,
                green: 96.0/255.0,
                blue: 176.0/255.0,
                alpha: 1.0
            )
            
           
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 40),
                button.widthAnchor.constraint(equalToConstant: 350),
            ])

            if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: spacing).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: headerHeight + spacing).isActive = true
            }

            previousButton = button

            // Connect each button to its corresponding segue
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        var destinationViewController: UIViewController?

        switch sender.titleLabel?.text {
        case "What is Eosinophilic Esophagitis (EOE)?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhatIsEOEViewController")
        case "How is it Diagnosed?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowItsDiagnosedViewController")
        case "How is it Treated?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HowItsTreatedViewController")
        case "Who is Affected?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhoIsAffectedViewController")
        case "What are Symptoms?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhatAreSymptomsViewController")
        case "What Causes EOE?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WhatCausesEOEViewController")
        case "Where Can I Find More Information?":
            destinationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreInfoViewController")
        default:
            break
        }

        if let destinationVC = destinationViewController {
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
