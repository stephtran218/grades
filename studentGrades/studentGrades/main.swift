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
var storedIndex: Int = 0


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
                displayAllStudentsGrades(storedIndex)
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
    
    if let student = readLine() {
        findStudent(student)
        print("\(student)'s grade in the class is \(finalGrades[storedIndex])")
    }
    print ()
}

func findStudent( _ userPick:String) -> Int{
    for i in studentNames.indices{
        if userPick.lowercased() == studentNames[i].lowercased(){
            return i
        }
    }
    return -1
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

func displayAllStudentsGrades( _ storedIndex: Int) {
    print("Which student would you like to choose?")
    
    if let pickedStudent = readLine(){
        var studentIndex =  findStudent(pickedStudent)
        if studentIndex < studentNames.count && studentIndex != -1{
            let pickedStudent = studentNames[studentIndex]

            print("\(pickedStudent)'s grades for this class are:")
            for grade in studentGrades[studentIndex]{
                print(grade, terminator:",")
            }
        }
    }
    print ()
}

func displayAllGradesForAllStudents(){

    for i in studentNames.indices {
        let name = studentNames[i]
        let grades = studentGrades[i]
        
        let cleanedGrades = grades.joined(separator: ", ")

        print("\(name)'s grades are: \(cleanedGrades)")
    }
    print()
}

func classAverage() -> Double {
    var totalSum: Double = 0
    var headCount: Int = 1
    
    for grades in studentGrades {
        for eachGrade in grades {
            if let grade = Double(eachGrade) {
                totalSum += grade
                headCount += 1
            }
        }
    }
    
    let average = totalSum / Double(headCount)
    let roundedAverage = (average * 100).rounded() / 100
    print("The class average is: \(roundedAverage)")
    print()

    return roundedAverage

}
func assignmentGradeAverage() {
    print("Which assignment would you like to get the average of (1-10):")

    if let chosenAssignment = readLine(), let assignmentNumber = Int(chosenAssignment){
        // Ensure the input is a valid integer between 1 and 10
        
        var totalSum: Double = 0
        var count: Int = 0
        
        // Iterate through each student's grades for the chosen assignment
        for grades in studentGrades {
            let assignmentIndex = assignmentNumber - 1
            if assignmentIndex < grades.count, let grade = Double(grades[assignmentIndex]) {
                totalSum += grade
                count += 1
            }
        }
        
        if count > 0 {
            let average = totalSum / Double(count)
            let roundedAverage = (average * 100).rounded() / 100

            print("The average grade for assignment \(assignmentNumber) is: \(roundedAverage)")
            print ()
        }  else {
            print("Please enter a valid assignment number between 1 and 10.")
        }
    }
}

func classLowestGrade(){
    
}

func classHighestGrade(){
    
}

func studentsByGradeRange(){
    
}

func quitMenu(){
    
}
