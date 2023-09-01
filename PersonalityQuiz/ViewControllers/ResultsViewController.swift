//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by Matvei Khlestov on 22.05.2022.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // MARK: - Public Properties
    var answers: [Answer]!
    
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var animalTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы – 🐶!"
        label.font = UIFont.systemFont(ofSize: 50)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Вам нравится быть с друзьями. Вы окружаете себя людьми, которые вам нравятся и всегда готовы помочь."
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .justified
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private Methods
extension ResultsViewController {
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        setupSubviewsForStackView(animalTypeLabel, descriptionLabel)
        
        setupNavController()
        
        updateResult()
        
        setConstraints()
    }
    
    private func setupNavController() {
        title = "Результат"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        navigationItem.hidesBackButton = true
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupSubviewsForStackView(_ subviews: UIView... ) {
        for subview in subviews {
            stackView.addArrangedSubview(subview)
        }
    }
    
    private func updateResult() {
        var frequencyOfAnimals: [Animal: Int] = [:]
        let animals = answers.map { $0.animal }
        
        for animal in animals {
            if let animalTypeCount = frequencyOfAnimals[animal] {
                frequencyOfAnimals.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                frequencyOfAnimals[animal] = 1
            }
        }
        
        /*
         for animal in animals {
         frequencyOfAnimals[animal] = (frequencyOfAnimals[animal] ?? 0) + 1
         }
         */
        
        let sortedFrequencyOfAnimals = frequencyOfAnimals.sorted { $0.value > $1.value }
        guard let mostFrequencyAnimal = sortedFrequencyOfAnimals.first?.key else { return }
        
        // Решение в одну строку:
        /*
         let mostFrequencyAnimal = Dictionary(grouping: answers) { $0.type }
         .sorted { $0.value.count > $1.value.count }
         .first?.key
         */
        
        updateUI(with: mostFrequencyAnimal)
    }
    
    private func updateUI(with animal: Animal?) {
        animalTypeLabel.text = "Вы - \(animal?.rawValue ?? "🐶" )!"
        descriptionLabel.text = animal?.definition ?? ""
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stackView.centerYAnchor.constraint(
                    equalTo: view.centerYAnchor
                ),
                stackView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
                stackView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -16
                )
            ]
        )
    }
}
