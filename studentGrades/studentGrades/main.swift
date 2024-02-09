//
//  main.swift
//  studentGrades
//
//  Created by StudentAM on 1/29/24.


import Foundation
import CSV

//These are the global variables that hold arrays of info (roster, grades, index, etc.)
var studentNames: [String] = []
var studentGrades: [[String]] = []
var finalGrades: [Double] = []
var numOfAssignments: Int = 0
var storedIndex: Int = 0

//This is a safety parameter that prevents errors from crashing the code
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

//This function sorts the original array with names in one, all grades in one, and final grades in one
func manageData( _ studentInfo: [String]) {
    //This array will hold just the grades for every assignments as strings
    var tempGrades: [String] = []
    //This for loop will go in the studentInfo array to look through every indice and sort it out. Typically, the 0-index is just the name so it sorts that in the names array
    for i in studentInfo.indices{
        if i == 0{
            studentNames.append(studentInfo[0])
            //If it's not in the 0-index, it will be sorted int he tempGrades array which holds all the assignment grades
        } else {
            tempGrades.append(studentInfo[i])
        }
    }
    //studentGrades is an array thats holding the tempGrades array so that it can look through all the grades in the class
    studentGrades.append(tempGrades)
    calcFinalGrade(tempGrades)
}

mainMenu()

//this is the main menu function which allows user to look at all the options
func mainMenu() {
    var menuChoice: String = "0"
    //This while loop keeps the program going so it doesn't shut down after each function. It will only end when the user puts in "9" to quit
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
        
        //This allows the user to put in an option and the code will call te function to what they chose
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
    
    //This asks the user which student they want to see their grade and it will call the function to find the student
    if let student = readLine() {
        findStudent(student)
        print("\(student)'s grade in the class is \(finalGrades[storedIndex])")
    }
    print ()
}

//This will take what the user put in and search through the for loop for the student and their name's index
func findStudent( _ userPick:String) -> Int{
    for i in studentNames.indices{
        //This makes it not case sensitive
        if userPick.lowercased() == studentNames[i].lowercased(){
            return i
        }
    }
    //if the -1 gets returned, this means the student couldn't be found since there is no student in the -1 index
    return -1
}

func calcFinalGrade( _ tempGrades: [String]){
    //This variable will account for all the points and add it so we can find the average
    var sumOfScores: Double = 0
    
    //This for loop will go through the array and add the grade into the variable as a DOUBLE
    for eachGrade in tempGrades{
        if let grade = Double(eachGrade){
            sumOfScores += grade
        }
    }
    //finalGrades will append the calculated grade by taking the total points and divide it by the number of assignments per each student
    finalGrades.append(sumOfScores/Double(tempGrades.count))
}

func displayAllStudentsGrades( _ storedIndex: Int) {
    print("Which student would you like to choose?")
    
    if let pickedStudent = readLine(){
        //studentIndex holds the student's # in the roster
        var studentIndex =  findStudent(pickedStudent)
        //If their index is less than the total number of students, that means they are part of the class
        if studentIndex < studentNames.count && studentIndex != -1{
            let pickedStudent = studentNames[studentIndex]
            
            print("\(pickedStudent)'s grades for this class are:")
            //This takes studentIndex and matches it with the correct index in stuentGrades to mtch the correct scores to the student's name
            for grade in studentGrades[studentIndex]{
                //This will seperate the grades w/ commas
                print(grade, terminator:",")
            }
        }
    }
    print ()
}

func displayAllGradesForAllStudents(){

    //This for loop allows the code to go through every student and their grade and print them together, it will be correctly printed together bc they should have the correct index per each array
    for i in studentNames.indices {
        let name = studentNames[i]
        let grades = studentGrades[i]
        
        //This removes the excess brackets and seperate the scores w/ commas
        let cleanedGrades = grades.joined(separator: ", ")

        print("\(name)'s grades are: \(cleanedGrades)")
    }
    print()
}

func classAverage() -> Double {
    var totalSum: Double = 0
    var headCount: Int = 1
    
    //This will find the class average by taking a sum of ALL grades of every student in the class to divide it w/ num of students (headCount)
    for grades in studentGrades {
        for eachGrade in grades {
            if let grade = Double(eachGrade) {
                totalSum += grade
                //This calculates the num of students everytime the for loop repeats per grades
                headCount += 1
            }
        }
    }
   
    //this performs the calculates to the grade
    let average = totalSum / Double(headCount)
    //This rounds the total average t just two decimal places
    let roundedAverage = (average * 100).rounded() / 100
    print("The class average is: \(roundedAverage)")
    print()

    return roundedAverage

}
func assignmentGradeAverage() {
    print("Which assignment would you like to get the average of (1-10):")

    if let chosenAssignment = readLine(), let assignmentNumber = Int(chosenAssignment){
        // to make sure the input isn't read as a string, it will be taken as an integer so that it can be matched to the grades' index later
        
        var totalSum: Double = 0
        var count: Int = 0
        
        // this goes through the grades array and match the index of the array with the assignment number the user put in
        for grades in studentGrades {
            //This makes sure it accounts for the 0-index assignment too
            let assignmentIndex = assignmentNumber - 1
            //this will take the grade in the string and make it a double so that we can use it to calculate the average later
            if assignmentIndex < grades.count, let grade = Double(grades[assignmentIndex]) {
                totalSum += grade
                //This counts for every student by adding one everytime it goes through the loop (assuming every student got a grade for the same asignment)
                count += 1
            }
        }
        //If it counted at last one student, it will calculate the assignment average
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
    //we are assuming the lowest grade starts off with the first grade (0-index)
    var lowestGrade: Double = finalGrades[0]
    var lowestGradeIndex: Int = -1
    var lowestGradeStudentName = ""

    //this goes through all the grades in class and compares each grade
    for i in finalGrades.indices {
        //If the grade that was saved is greater than the grade being compared to in the array, the lowest grade var will now hold the lower grade that was being compared to (finalGrades[i])
        if lowestGrade > finalGrades[i]{
            lowestGrade = finalGrades[i]
            //This saves the index where the lowest grade was found so we can match it to a name through matching up the indices
            lowestGradeIndex = i
        }
    }
    //If the lowestGrade found wasn't in the -1 index, meaning there wasn;t an error and the index is part of the range in numOfStudents, it will find the correct name of the student w/ low grade
    if lowestGradeIndex != -1 && lowestGradeIndex < studentNames.count{
        lowestGradeStudentName = studentNames[lowestGradeIndex]
    }
    print("\(lowestGradeStudentName) is the student with the lowest grade: \(lowestGrade)")
    
    print ()
}

func classHighestGrade(){
    //This is assuming the first grade in array is highest so that it can be compared to each index
    var highestGrade: Double = finalGrades[0]
    var highestGradeIndex: Int = -1
    var highestGradeStudentName = ""

    for i in finalGrades.indices {
        //Everytime the loop runs, if the current index is greater than the highestGrade, it will replace that index with the current one
        if highestGrade < finalGrades[i]{
            highestGrade = finalGrades[i]
            //This saves the index that was holding the highest grade
            highestGradeIndex = i
        }
    }
    //If there wasn't an error and it correctly found the highest grade, it will take the saved index and match it to a name
    if highestGradeIndex != -1 && highestGradeIndex < studentNames.count{
        highestGradeStudentName = studentNames[highestGradeIndex]
    }
    print("\(highestGradeStudentName) is the student with the highest grade: \(highestGrade)")
    
    print ()
}

func studentsByGradeRange(){
    print("Enter the low range you would like to use:")
    
    //this takes both ranges the user put in and saves it as parameters(range)
    if let lowRangeString = readLine(), let lowRange = Double(lowRangeString) {
        print("Enter the high range you would like to use:")
        if let highRangeString = readLine(), let highRange = Double(highRangeString) {
            //this will go through the final grades array to see all students grades
            for i in finalGrades.indices{
                //this var will take the scores per each indice
                let studentInRange = finalGrades[i]
                //if the score is between the range, their name will be printed because it matched the index from the finalGrades w the roster array
                if studentInRange >= lowRange && studentInRange <= highRange {
                    if i < studentNames.count{
                        print(studentNames[i])
                    }
                }
            }
            print()
        }
    }
}

//this prints the message and ends the code
func quitMenu(){
    print ("Have a great rest of your day!")
}
