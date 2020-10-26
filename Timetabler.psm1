Function Merge-TTTdf9{
    param(
        $file1,
        $file2,
        $file3,
        $output
    )
    if($file3){
        [xml]$tdf91 = Get-Content $file1
        [xml]$tdf92 = Get-Content $file2
        [xml]$tdf93 = Get-Content $file3

        Foreach ($Node in $tdf93.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }
        Foreach ($Node in $tdf92.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }

        $tdf91.Save("$output")
    }
    elseif (-Not ($file3) -and $file2) {
        [xml]$tdf91 = Get-Content $file1
        [xml]$tdf92 = Get-Content $file2

        Foreach ($Node in $tdf92.DocumentElement.ChildNodes) {
            $tdf91.DocumentElement.AppendChild($tdf91.ImportNode($Node, $true))
        }

        $tdf91.Save("$output")
    }
}

function Get-TTTeacher {
    param (
        $file,
        $searchstring,
        $xml
    )
    if ($file) {
        [xml]$xml = Get-Content $file        
    }

    $teachers = $xml.TimetableDevelopmentData.Teachers.Teacher
    $teachers | ? {$_.code -like "*$searchstring*" -or $_.Firstname -like "*$searchstring*" -or $_.LastName -like "*$searchstring*"}
}

function Get-TTStudent {
    param (
        $file,
        $searchstring,
        $xml
    )
    if ($file) {
        [xml]$xml = Get-Content $file    
    }
    else{
        [xml]$xml = $xml
    }

    $students = $xml.TimetableDevelopmentData.Students.Student
    $students | Where-Object {$_.code -like "*$searchstring*" -or $_.FirstName -like "*$searchstring*" -or $_.FamilyName -like "*$searchstring*"}
}

function Get-TTClass {
    param (
        $file,
        $searchstring,
        $xml
    )
    if($file){
        [xml]$xml = Get-Content $file
    }
    else{
        [xml]$xml = $xml
    }

    $classes = $xml.TimetableDevelopmentData.Classes.Class
    $classes | ? {$_.code -like "*$searchstring*" -or $_.Name -like "*$searchstring*"}
}

function Get-TTClassList {
    param (
        $file,
        $xml,
        $classid,
        $studentid,
        $teacherid,
        [switch]$cleanoutput
    )
    if ($file) {
        [xml]$xml = Get-Content $file    
    }
    else{
        [xml]$xml = $xml
    }
    
    $courses = $xml.TimetableDevelopmentData.Courses.Course
    $studentlessons = $xml.TimetableDevelopmentData.StudentLessons.StudentLesson
    $teachers = $xml.TimetableDevelopmentData.Teachers.Teacher
    $classes = $xml.TimetableDevelopmentData.Classes.Class
    $students = $xml.TimetableDevelopmentData.Students.Student

    <#? This outputs the teacher and students of the class#>
    if ($classid) {
        $course = $courses | ? {$_.ClassID -eq $classid}
        $teacher = $teachers | ? {$_.TeacherID -eq $course.TeacherID}
        $class = $classes | ? {$_.ClassID -eq $classid}
        $classstudents = $studentlessons | Where-Object {$_.Classcode -eq $class.code}
        $studentlist = @()
        foreach($s in $classstudents){
            $studentlist += $students | ? {$_.StudentId -eq $s.StudentID}
        }
        if($cleanoutput){
            Write-Host "Class is: " $class.Name
            Write-host "Teacher is: " $teacher.firstName $teacher.LastName
            Write-Host "Students are: "
            foreach($stud in $studentlist){
                write-host $stud.Firstname $stud.FamilyName
            }
        }
        Else{
            $teacher
            $studentlist
        }
    }

    <#? This outputs the classes the student is in#>
    if ($studentid) {
        $classstudents = $studentlessons | ? {$_.StudentID -eq $studentid}
        
    }

    <#? This outputs the classes a teacher runs#>
    if ($teacherid) {
        
    }
}