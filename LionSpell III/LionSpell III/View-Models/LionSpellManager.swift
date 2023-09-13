//
//  LionSpellManager.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import Foundation

class LionSpellManager : ObservableObject {
    
    // The Model
    var scramble : OneScramble = OneScramble(preferences: Preferences(lang: .english, probSize: .easy))
    
    @Published var gamePreferences: Preferences = Preferences(lang: .english, probSize: .easy) {
        didSet{
            pressNewGameButton()
        }
    }
    
    @Published var confetti: Int = 0 {
        didSet {
            alerting = true
        }
    }
    
    @Published var alerting: Bool = false
    
    @Published var showPreferences: Bool = false // true if preferences clicked, false otherwise
    
    @Published var showHints: Bool = false // true if hints clicked, false otherwise
    
    @Published var canSubmit: Bool = false // true if valid word, false otherwise
        
    // Published vars for data that the view needs to respond/update
    @Published var guessedLetters: [String] = [" "] {
        didSet {
            let guessedLettersString = guessedLetters.joined(separator: "")
            // If the word is in the list and is not already guessed
            if scramble.words.contains(guessedLettersString.lowercased()) && !wordsFound.contains(guessedLettersString) && guessedLettersString.contains(scramble.letters[0]) {
                canSubmit = true
            }
            else {
                canSubmit = false
            }
        }
    }
    
    @Published var score = 0    // User's score
    
    @Published var wordsFound: [String] = [" "]     // List of words already found by the user, initialized to [" "] to create a default view
    
    // Action for pressing a letter button
    func pressALetterButton(letter: String) {
        if guessedLetters.count == 1 && guessedLetters[0] == " " {
            guessedLetters.removeLast()
        }
        guessedLetters.append(letter)
    }
    
    // Calculates the score given a word
    private func getScore(word: [String]) -> Int {
        if word.count == 4 {
            return 1
        }
        else {
            return word.count + isPangram(word: word)
        }
    }
    
    // Returns 5 if a word is a pangram, 0 otherwise
    private func isPangram(word: [String]) -> Int {
        for l in scramble.letters {
            if !word.contains(l) {
                return 0
            }
        }
        return gamePreferences.probSize.difficulty
    }
    
    // Action for pressing the submit button
    func pressSubmitButton() {
        let guessedLettersString = guessedLetters.joined(separator: "")
        if canSubmit {
            score = score + getScore(word: guessedLetters)
            // If it is in the initialized state
            if wordsFound.count == 1 && wordsFound[0] == " " {
                wordsFound.removeLast()
            }
            wordsFound.append(guessedLettersString)
            guessedLetters = [" "]
            if wordsFound.count == getWords().count {
                confetti = confetti + 1
            }
        }
        else {
            print("Invalid word!")
        }
    }
    
    // Action for pressing the delete button
    func pressDeleteButton() {
        if guessedLetters.count != 0 {
            guessedLetters.removeLast()
            // Reinitialize starting state
            if guessedLetters.count == 0 {
                guessedLetters.append(" ")
            }
        }
        else {
            print("Nothing to delete!")
        }
    }
    
    // Action for pressing the new game button
    func pressNewGameButton() {
        canSubmit = false
        guessedLetters = [" "]
        score = 0
        wordsFound = [" "]
        alerting = false
        scramble = scramble.restart(lang: gamePreferences.lang, probSize: gamePreferences.probSize)
    }
    
    // Action for pressing the preferences button
    func pressPreferencesButton() {
        showPreferences = true
    }
    
    // Action for pressing the hints button
    func pressHintsButton() {
        showHints = true
    }
    
    // Function for testing if a word is an anagram of another word
    func isAnagram(s: String) -> Bool {
        for c in s {
            if !scramble.letters.contains(String(c).uppercased()) {
                return false
            }
        }
        return true
    }
    
    // Determines the total number of possible words
    func getWords() -> [String] {
        var possibleWords: [String] = []
        for w in scramble.words {
            if isAnagram(s: w) && Array(w).contains(scramble.letters[0].lowercased()) {
                possibleWords.append(w.uppercased())
            }
        }
        return possibleWords
    }
    
    // Determines the number of points given an array of words
    func getPoints(words: [String]) -> Int {
        var pts: Int = 0
        for w in words {
            pts = pts + getScore(word: w.map { String($0) })
        }
        return pts
    }
    
    // Determines the number of pangrams given an array of words
    func getPangrams(words: [String]) -> [String] {
        var pangrams: [String] = []
        for w in words {
            if isPangram(word: w.map { String($0) }) != 0 {
                pangrams.append(w)
            }
        }
        return pangrams
    }
    
    // Returns an array of the possible word lengths given an array of words
    func getPossibleWordLengths(words: [String]) -> [Int] {
        var possibleWordLengths: [Int] = []
        for w in words {
            if !possibleWordLengths.contains(w.count) {
                possibleWordLengths.append(w.count)
            }
        }
        possibleWordLengths.sort()
        return possibleWordLengths
    }
    
    // Returns an array of words of given length from the given array that start with the given letter
    func getWordsOfLength(words: [String], len: Int, start: String) -> [String] {
        var wordsOfLength: [String] = []
        for w in words {
            if w.count == len && String(w.first!) == start {
                wordsOfLength.append(w)
            }
        }
        return wordsOfLength
    }
    
    
    // Determines the number of words found
    func getWordsFoundLen() -> Int {
        // If in the starting state
        if wordsFound.count == 1 && wordsFound[0] == " " {
            return 0
        }
        else {
            return wordsFound.count
        }
    }
}

