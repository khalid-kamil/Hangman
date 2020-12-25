//
//  ViewController.swift
//  Milestone4
//
//  Created by Khalid Kamil on 12/23/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var lifeOneLabel: UIImageView!
    @IBOutlet var lifeTwoLabel: UIImageView!
    @IBOutlet var lifeThreeLabel: UIImageView!
    @IBOutlet var lifeFourLabel: UIImageView!
    @IBOutlet var lifeFiveLabel: UIImageView!
    @IBOutlet var lifeSixLabel: UIImageView!
    @IBOutlet var lifeSevenLabel: UIImageView!
    @IBOutlet var currentAnswer: UITextField!
    @IBOutlet var buttonsView: UIView!
    
    let alphabet: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var allWords = [String]()
    var selectedWord: String? = ""
    var hiddenWord: String? = ""
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var wrongButtons = 0
    
    var livesArray = [UIImageView]()
    
    var correctLetters = 0
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Hangman"
        
        view.backgroundColor = UIColor(red: 253/255, green: 253/255, blue: 150/255, alpha: 1)
        
        
        // Choose a random word from a list of possibilities
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
            
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
            startGame()
        }
        
//        currentAnswer.backgroundColor = UIColor(red: 108/255, green: 110/255, blue: 186/255, alpha: 1)
        currentAnswer.textColor = .black
        currentAnswer.layer.borderWidth = 1.0
        currentAnswer.layer.cornerRadius = 25.0
        currentAnswer.layer.borderColor = UIColor.black.cgColor
        
        let width = 58
        let height = 50
        var letterCount = 0
        
        // Create 26 buttons as a 4x6 grid
        outerLoop: for row in 0..<5 {
            for col in 0..<6 {
                if letterCount == 26 {
                    break outerLoop
                } else {
                    letterCount += 1
                }
                // Create a new button
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                letterButton.tintColor = .black
                
                // Give the button some temporary text so we can see it on screen
                letterButton.setTitle(String(Array(alphabet)[letterCount-1]) , for: .normal)
                
                
                // Calculate the frame of this button using its column and row
                let frame = CGRect(x: col*width, y: row*height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to out letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
        // Let the user guess letters one at a time
        
        // If they guess a correct letter that is in the word, it gets revealed amogn the underscores
        
        // If they guess an incorrect letter, they inch closer to death
        
        // If they get seven incorrect answers they lose
        
        // If they manage to spell the full word before that they win
        
        
    }
    
    func startGame() {
        hiddenWord = ""
        livesArray = [lifeOneLabel, lifeTwoLabel, lifeThreeLabel, lifeFourLabel, lifeFiveLabel, lifeSixLabel, lifeSevenLabel]
        for life in livesArray {
            life.image = UIImage(systemName: "heart.fill")
            life.tintColor = .black
        }
        selectedWord = allWords.randomElement()?.uppercased()
        
        // Present the word to the user as a list of undescores
        for _ in selectedWord! {
            hiddenWord?.append("?")
        }
        currentAnswer.text = hiddenWord

    }
    
    @objc func letterTapped(_ sender: UIButton) -> Void {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        checkAnswer(answer: buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    func checkAnswer(answer: String) -> Void {
        var letterFound = false
        let selectedLetter = answer.uppercased()
        for (index, letter) in selectedWord!.enumerated() {
            if String(letter) == selectedLetter {
                letterFound = true
                let characterIndex = NSMakeRange(index, 1)
                let swiftRange = Range(characterIndex, in: selectedWord!)
                hiddenWord = hiddenWord!.replacingCharacters(in: swiftRange!, with: String(letter))
                currentAnswer.text = hiddenWord
            }
        }
        if !letterFound {
            wrongButtons += 1
            if wrongButtons < 7 {
                showRemainingLives()
            } else {
                let ac = UIAlertController(title: "Game Over!", message: "You are out of lives. The correct word was '\(selectedWord!)'.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: restartGame))
                present(ac, animated: true, completion: nil)
            }
        } else {
            if hiddenWord == selectedWord {
                let ac = UIAlertController(title: "Congratulations!", message: "You guessed the right word.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: restartGame))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    func showRemainingLives() {
        livesArray[wrongButtons-1].image = UIImage(systemName: "heart")
    }
    
    func restartGame(action: UIAlertAction) {
        wrongButtons = 0
        startGame()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }

}

