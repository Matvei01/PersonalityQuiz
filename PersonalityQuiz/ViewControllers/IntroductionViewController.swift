//
//  IntroductionViewController.swift
//  PersonalityQuiz
//
//  Created by Matvei Khlestov on 21.05.2022.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var whatAnimalLabel: UILabel = {
        createLabel(
            text: "Какое вы животное?",
            font: UIFont.systemFont(ofSize: 30)
        )
    }()
    
    private lazy var dogLabel: UILabel = {
        createLabel(
            text: "🐶",
            font: UIFont.systemFont(ofSize: 30)
        )
    }()
    
    private lazy var catLabel: UILabel = {
        createLabel(
            text: "🐱",
            font: UIFont.systemFont(ofSize: 30)
        )
    }()
    
    private lazy var rabbitLabel: UILabel = {
        createLabel(
            text: "🐰",
            font: UIFont.systemFont(ofSize: 30)
        )
    }()
    
    private lazy var turtleLabel: UILabel = {
        createLabel(
            text: "🐢",
            font: UIFont.systemFont(ofSize: 30)
        )
    }()
    
    private lazy var startPollButton: UIButton = {
        var attributes = AttributeContainer()
        attributes.font = .systemFont(ofSize: 20)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.attributedTitle = AttributedString("Начать опрос", attributes: attributes)
        
        let button = UIButton(
            configuration: buttonConfiguration,
            primaryAction: UIAction { [unowned self] _ in
                startPollButtonPressed()
            })
        
        return button
    }()
    
    // MARK: - Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Private Methods
extension IntroductionViewController {
    private func configure() {
        view.backgroundColor = .white
        
        setupSubviews(
            stackView,
            dogLabel,
            catLabel,
            rabbitLabel,
            turtleLabel
        )
        
        setupSubviewsForStackView(whatAnimalLabel, startPollButton)
        
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    private func setupSubviewsForStackView(_ subviews: UIView... ) {
        for subview in subviews {
            stackView.addArrangedSubview(subview)
        }
    }
    
    private func createLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        
        return label
    }
    
    private func startPollButtonPressed() {
        let questionVC = UINavigationController(
            rootViewController: QuestionsViewController()
        )
        questionVC.modalPresentationStyle = .fullScreen
        present(questionVC, animated: true)
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stackView.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
                ),
                stackView.centerYAnchor.constraint(
                    equalTo: view.centerYAnchor
                )
            ]
        )
        
        dogLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                dogLabel.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
                dogLabel.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 20
                ),
            ]
        )
        
        catLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                catLabel.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
                catLabel.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -20
                )
            ]
        )
        
        rabbitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                rabbitLabel.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -20
                ),
                rabbitLabel.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 20
                ),
            ]
        )
        
        turtleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                turtleLabel.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -20
                ),
                turtleLabel.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -20
                )
            ]
        )
    }
}

