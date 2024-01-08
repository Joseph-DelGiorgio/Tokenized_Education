// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AttendanceAndGrading {

    // Structure to represent a student
    struct Student {
        bool isEnrolled;                // Flag indicating whether the student is enrolled
        mapping(uint256 => bool) attendance;  // Mapping to store attendance for each class (represented by a timestamp)
        uint256 totalClasses;           // Total number of classes
        uint256 totalAttendance;        // Total number of attended classes
        uint256 totalGradePoints;       // Total grade points
        uint256 totalSubjects;          // Total number of subjects
    }

    // Mapping to store students by their Ethereum addresses
    mapping(address => Student) public students;

    // Event to notify when attendance is marked
    event AttendanceMarked(address indexed student, uint256 timestamp);

    // Event to notify when grades are updated
    event GradesUpdated(address indexed student, uint256 totalGradePoints, uint256 totalSubjects);

    // Function to enroll a student
    function enrollStudent() public {
        require(!students[msg.sender].isEnrolled, "Student already enrolled");

        students[msg.sender].isEnrolled = true;
    }

    // Function to mark attendance for a student
    function markAttendance(uint256 timestamp) public {
        require(students[msg.sender].isEnrolled, "Student not enrolled");
        require(!students[msg.sender].attendance[timestamp], "Attendance already marked for this class");

        students[msg.sender].attendance[timestamp] = true;
        students[msg.sender].totalAttendance++;
        students[msg.sender].totalClasses++;

        // Emit an event to notify the marking of attendance
        emit AttendanceMarked(msg.sender, timestamp);
    }

    // Function to update grades for a student
    function updateGrades(uint256 totalGradePoints, uint256 totalSubjects) public {
        require(students[msg.sender].isEnrolled, "Student not enrolled");

        students[msg.sender].totalGradePoints = totalGradePoints;
        students[msg.sender].totalSubjects = totalSubjects;

        // Emit an event to notify the update of grades
        emit GradesUpdated(msg.sender, totalGradePoints, totalSubjects);
    }

    // Function to get the attendance status of a student for a specific class
    function getAttendanceStatus(address studentAddress, uint256 timestamp) public view returns (bool) {
        return students[studentAddress].attendance[timestamp];
    }

    // Function to get the overall performance of a student
    function getStudentPerformance(address studentAddress) public view returns (uint256, uint256, uint256) {
        return (
            students[studentAddress].totalClasses,
            students[studentAddress].totalAttendance,
            students[studentAddress].totalGradePoints
        );
    }
}
