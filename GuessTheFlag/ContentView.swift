//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Travis Brigman on 1/30/21.
//  Copyright © 2021 Travis Brigman. All rights reserved.
//

import SwiftUI

//custom modifier - this can be implemented anywwhere and can reduce lines of code in the contentView
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

struct FlagImage: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var number: Int
    var countries: [String]
    
    var body: some View {       
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            .shadow(color: .black, radius: 2)
            .accessibility(label: Text(self.labels[self.countries[number], default: "unknown flag"]))
    }
    
}

struct ContentView: View {
    

    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var userScore = 0
    
    @State private var animationAmount = 0.0
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) {
                    number in
                    Button(action: {
                        self.flagTapped(number)
                        withAnimation {
                            if number == self.correctAnswer {
                                self.animationAmount += 360
                            }
                            
                        }
                    }) {
                        FlagImage(number: number, countries: self.countries)
                            .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        
                    }
                }
                Text("Current Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                })
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            userScore += 1
        }
        
        let flagTapped = countries[number]
        
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        
        if number != correctAnswer {
            scoreMessage = "Wrong! That's the flag of \(flagTapped)"
        } else {
            scoreMessage = "Your Score is \(userScore)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
