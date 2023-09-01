//
//  QuestionsViewController.swift
//  PersonalityQuiz
//
//  Created by Matvei Khlestov on 22.05.2022.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    // MARK: - Public Properties
    var singleButtons: [UIButton] = []
    var multipleLabels: [UILabel] = []
    var multipleSwitches: [UISwitch] = []
    var multipleStackViews: [UIStackView] = []
    var rangedLabels: [UILabel] = []
    
    // MARK: - Private Properties
    private let questions = Question.getQuestions()
    private var answerChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    private var questionIndex = 0
    
    // MARK: - UI Elements
    private lazy var singleStackView: UIStackView = {
        createVerticalStackView(alignment: .center, spacing: 16)
    }()
    
    private lazy var mainMultipleStackView: UIStackView = {
        createVerticalStackView(alignment: .fill, spacing: 16)
    }()
    
    private lazy var mainRangedStackView: UIStackView = {
        createVerticalStackView(alignment: .fill, spacing: 8)
    }()
    
    private lazy var rangedStackView: UIStackView = {
        createHorizontalStackView(distribution: .fillEqually)
    }()
    
    
    private lazy var questionProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.5
        
        return progressView
    }()
    
    private lazy var multipleAnswerButton: UIButton = {
        createAnswersButton(
            withAction: UIAction { [unowned self] _ in
                multipleAnswerButtonPressed()
            })
    }()
    
    private lazy var rangedAnswersButton: UIButton = {
        createAnswersButton(
            withAction: UIAction { [unowned self] _ in
                rangedAnswersButtonPressed()
            })
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "questionLabel"
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var rangedSlider: UISlider = {
        let answerCount = Float(currentAnswers.count - 1)
        let slider = UISlider()
        slider.maximumValue = answerCount
        slider.value = answerCount / 2
        
        return slider
    }()
    
    // MARK: - Life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateUI()
    }
}

// MARK: - Private Methods
extension QuestionsViewController {
    private func configure() {
        view.backgroundColor = .white
        setupSubviews(
            questionLabel,
            questionProgressView,
            singleStackView,
            mainMultipleStackView,
            mainRangedStackView
        )
        
        setupSingleAnswerButton()
        
        setupMultipleUIElements()
        
        setupRangedUIElements()
        
        setupNavController()
        
        setConstraints()
    }
    
    private func setupNavController() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    private func setupSubviewsFor(stackView: UIStackView, subviews: UIView... ) {
        for subview in subviews {
            stackView.addArrangedSubview(subview)
        }
    }
    
    private func updateUI() {
        for stackView in [singleStackView, mainMultipleStackView, mainRangedStackView] {
            stackView.isHidden = true
        }
        
        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.title
        
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        questionProgressView.setProgress(totalProgress, animated: true)
        
        title = "Вопрос №\(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultipleStackView(with: currentAnswers)
        case .ranged:
            showRangedStackView(with: currentAnswers)
        }
    }
    
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            
            return
        }
        
        let resultsVC = ResultsViewController()
        resultsVC.answers = answerChosen
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    private func showMultipleStackView(with answers: [Answer]) {
        mainMultipleStackView.isHidden.toggle()
        
        for(label, answer) in zip(multipleLabels, answers) {
            label.text = answer.title
        }
    }
    
    private func showRangedStackView(with answers: [Answer]) {
        mainRangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    private func createVerticalStackView(alignment: UIStackView.Alignment,
                                         spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = alignment
        stackView.distribution = .fill
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func createHorizontalStackView(distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = distribution
        stackView.spacing = 0
        
        return stackView
    }
    
    private func createAnswersButton(withAction action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = .systemFont(ofSize: 16)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.attributedTitle = AttributedString("Ответить", attributes: attributes)
        
        let button = UIButton(
            configuration: buttonConfiguration,
            primaryAction: action
        )
        
        return button
    }
    
    private func setupSingleAnswerButton() {
        for index in 0...3 {
            let singleButton: UIButton = {
                var attributes = AttributeContainer()
                attributes.font = .systemFont(ofSize: 15)
                
                var buttonConfiguration = UIButton.Configuration.plain()
                buttonConfiguration.attributedTitle = AttributedString("Button1", attributes: attributes)
                
                let button = UIButton(configuration: buttonConfiguration)
                button.tag = index
                button.addTarget(self, action: #selector(singleAnswerButtonPressed), for: .touchUpInside)
                
                return button
            }()
            
            singleButtons.append(singleButton)
            singleStackView.addArrangedSubview(singleButton)
        }
    }
    
    @objc private func singleAnswerButtonPressed(sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answerChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    private func multipleAnswerButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answerChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    private func rangedAnswersButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answerChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    private func setupMultipleUIElements() {
        for index in 0...3 {
            let multipleLabel: UILabel = {
                let label = UILabel()
                label.text = "multipleLabel1"
                label.font = UIFont.systemFont(ofSize: 17)
                label.tag = index
                
                return label
            }()
            
            multipleLabels.append(multipleLabel)
            
            let multipleSwitch: UISwitch = {
                let multipleSwitch = UISwitch()
                multipleSwitch.setOn(true, animated: true)
                multipleSwitch.tag = index
                
                return multipleSwitch
            }()
            
            multipleSwitches.append(multipleSwitch)
            
            let multipleStackView: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .fill
                stackView.distribution = .fill
                stackView.spacing = 0
                stackView.tag = index
                
                return stackView
                
            }()
            
            multipleStackViews.append(multipleStackView)
            
            setupSubviewsFor(
                stackView: mainMultipleStackView,
                subviews: multipleStackView, multipleAnswerButton
            )
            
            setupSubviewsFor(
                stackView: multipleStackView,
                subviews: multipleLabel, multipleSwitch
            )
        }
    }
    
    private func setupRangedUIElements() {
        for index in 0...1 {
            let rangedLabel: UILabel = {
                let label = UILabel()
                label.tag = index
                
                if label.tag == 0 {
                    label.text = "rangedLabel"
                    label.font = UIFont.systemFont(ofSize: 17)
                } else {
                    label.text = "rangedLabe2"
                    label.font = UIFont.systemFont(ofSize: 17)
                    label.textAlignment = .right
                }
                
                return label
            }()
            
            rangedLabels.append(rangedLabel)
            
            setupSubviewsFor(
                stackView: rangedStackView,
                subviews: rangedLabel
            )
            
            setupSubviewsFor(
                stackView: mainRangedStackView,
                subviews: rangedSlider, rangedStackView, rangedAnswersButton
            )
        }
    }
    
    // MARK: - Constraints
    private func setConstraintsFor(_ stackViews: UIStackView...) {
        for stackView in stackViews {
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    stackView.centerYAnchor.constraint(
                        equalTo: view.centerYAnchor
                    ),
                    stackView.leadingAnchor.constraint(
                        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                        constant: 20
                    ),
                    stackView.trailingAnchor.constraint(
                        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                        constant: -20
                    )
                ]
            )
        }
    }
    
    private func setConstraints() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                questionLabel.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8
                ),
                questionLabel.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 20
                ),
                questionLabel.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -20
                )
            ]
        )
        
        questionProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                questionProgressView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0
                ),
                questionProgressView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 0
                ),
                questionProgressView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: 0
                )
            ]
        )
        
        setConstraintsFor(
            singleStackView,
            mainMultipleStackView,
            mainRangedStackView
        )
    }
}


