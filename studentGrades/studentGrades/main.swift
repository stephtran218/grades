//
//  main.swift
//  studentGrades
//
//  Created by StudentAM on 1/29/24.


import Foundation
import CSV

var studentNames: [String] = []
var studentGrades: [[String]] = []
var finalGrades: [Double] = []
var numOfAssignments: Int = 0

do{
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv" )
    let csv = try CSVReader(stream: stream!)
    
    while let row = csv.next(){
        manageData(row)
    }
}
catch{
    print("There was an error trying to read the file")
}

func manageData( _ studentInfo: [String]) {
    var tempGrades: [String] = []
    for i in studentInfo.indices{
        if i == 0{
            studentNames.append(studentInfo[0])
        } else {
            tempGrades.append(studentInfo[i])
        }
    }
    studentGrades.append(tempGrades)
    calcFinalGrade(tempGrades)
}

mainMenu()

func mainMenu() {
    var menuChoice: String = "0"
    while menuChoice != "9" {
        print("Welcome to the Grade Manager!\n",
              "What would you like to do? (Enter the number):\n",
              "1. Display grade of a single student\n",
              "2. Display all grades for a student\n",
              "3. Display all grades of ALL students\n",
              "4. Find the average grade of the class\n",
              "5. Find the average grade of an assignment\n",
              "6. Find the lowest grade in the class\n",
              "7. Find the highest grade of the class\n",
              "8. Filter students by grade range\n",
              "9. Quit\n")
        
        if let userPick = readLine() {
            if userPick == "1" {
                displaySingleStudentGrade()
            } else if userPick == "2" {
                displayAllStudentGrades()
            } else if userPick == "3" {
                displayAllGradesForAllStudents()
            } else if userPick == "4" {
                classAverage()
            } else if userPick == "5" {
                assignmentGradeAverage()
            } else if userPick == "6" {
                classLowestGrade()
            } else if userPick == "7" {
                classHighestGrade()
            } else if userPick == "8" {
                studentsByGradeRange()
            } else if userPick == "9" {
                quitMenu()
            } else {
                print("Please enter a valid selection 1-9")
            }
            menuChoice = userPick
        }
    }
}

func displaySingleStudentGrade() {
    print("Which student would you like to choose?")
    
    if let userPick = readLine() {
        findStudent(userPick)
    }
}

func findStudent( _ userPick:String){
    var storedIndex: Int = 0
    for i in studentNames.indices{
        if userPick == studentNames[i]{
            storedIndex = i
        }
    }
    print("\(userPick)'s grade in the class is \(finalGrades[storedIndex])")
}

func calcFinalGrade( _ tempGrades: [String]){
    var sumOfScores: Double = 0
    
    for eachGrade in tempGrades{
        if let grade = Double(eachGrade){
            sumOfScores += grade
        }
    }
    finalGrades.append(sumOfScores/Double(tempGrades.count))
}

func displayAllStudentGrades(){
    
}

func displayAllGradesForAllStudents(){
    
}

func classAverage(){
    
}

func assignmentGradeAverage(){
    
}

func classLowestGrade(){
    
}

func classHighestGrade(){
    
}

func studentsByGradeRange(){
    
}

func quitMenu(){
    
}
