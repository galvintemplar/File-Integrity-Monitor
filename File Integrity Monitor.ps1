Import-Module "C:\Users\Galvin\Desktop\BASICFILEMONITOR\Scripts\mail.ps1" 
Add-Type -AssemblyName System.Windows.Forms

$EmailCredentialsPath="C:\Users\Galvin\Desktop\BASICFILEMONITOR\Scripts\emailcreds.xml"
$EmailCredentialsPath=Import-Clixml -Path $EmailCredentialsPath
$EmailServer="smtp-mail.outlook.com"
$EmailPort="587"
function Add-FileToBaseline{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$baselineFilePath,
        [Parameter(Mandatory)]$targetFilePath
    )

    try{
        if((test-path -path $baselineFilePath) -eq $false){
            Write-Error -Message "$baselineFilePath does not exist" -ErrorAction Stop
        }
        if((test-path -path $targetFilePath) -eq $false){
            Write-Error -Message "$targetFilePath does not exist" -ErrorAction Stop
        }
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -ne ".csv"){
            Write-Error -Message "$baselineFilePath needs to be a .csv file" -ErrorAction Stop
        }

        $currentBaseline=Import-Csv -Path $baselineFilePath -Delimiter ","

        if($targetFilePath -in $currentBaseline.path){
            Write-Output "File path detected already in baseline file"
            do{
                $overwrite=Read-Host -Prompt "Path exists already in the baseline file, would you like to overwrite it [Y/N]"
                if($overwrite -in @('y','yes')){
                    Write-Output "File path will be overwritten"

                    $currentBaseline | where-object path -ne $targetFilePath | Export-Csv -Path $baselineFilePath -Delimiter "," -NoTypeInformation

                    $hash=Get-FileHash -Path $targetFilePath 
                    "path,hash" | Out-File -FilePath $baselineFilePath -Append
                    "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append


                    Write-Output "Entry succesfully added into baseline"

                }elseif($overwrite -in @('n','no')){
                        Write-Output "File path will not be overwritten"
                }else{
                        Write-Output "Invalid entry, please enter y to overwrite or n to not overwrite"
                }
            }while($overwrite -notin @('y','yes','n','no'))  
        }else{
           
            $hash=Get-FileHash -Path $baselineFilePath

            "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append

            Write-Output "Entry succesfully added into baseline"
        }

        $currentBaseline=Import-Csv -Path $baselineFilePath -Delimiter ","
        $currentBaseline | Export-Csv -Path $baselineFilePath -Delimiter "," -NoTypeInformation

        

    }catch{
        Write-Error $_.Exception.Message
    }
}

function Verify-Baseline{
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory)]$baselineFilePath,
        [Parameter()]$emailTo
    )

    try{
        if((test-path -path $baselineFilePath) -eq $false){
            Write-Error -Message "$baselineFilePath does not exist" -ErrorAction Stop
        }
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -ne ".csv"){
            Write-Error -Message "$baselineFilePath needs to be a .csv file" -ErrorAction Stop
        }

        $baselineFiles=Import-Csv -Path $baselineFilePath -Delimiter ","

        foreach($file in $baselineFiles){
             if(Test-Path -Path $file.path){
                $currenthash=Get-FileHash -Path $file.path
                if($currenthash.Hash -eq $file.hash){
                    Write-Output "$($file.path) is still the same"
                }else{
                    Write-Output "$($file.path) hash is different something has changed"
                    if($emailTo){
                        Send-MailKitMessage -From $EmailCredentialsPath.UserName -To $emailTo -Subject "file Monitor, file has changed" -Body "$($file.path) hash is different something has changed" -SMTPServer $EmailServer -Port $EmailPort -Credential $EmailCredentialsPath
                    }
        }
    }else{
        Write-Output "$($file.path) is not found!"
    }
} 
    }catch{
        Write-Error $_.exception.message
    }
}

function Create-Baseline{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]$baselineFilePath
    )

    try{
        if((test-path -path $baselineFilePath)){
            Write-Error -Message "$baselineFilePath already exists with this name" -ErrorAction Stop
        }
        if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -ne ".csv"){
            Write-Error -Message "$baselineFilePath needs to be a .csv file" -ErrorAction Stop
        }
        "path,hash" | Out-File -FilePath $baselineFilePath -Force
    }Catch{
        Write-Error $_.Exception.Message
    }
}

$baselineFilePath=""

Write-Host "File Monitor System Version 1.00" -ForegroundColor Green
do{
    Write-Host "Please select one of the following options or enter q or quit to quit" -ForegroundColor Green
    Write-Host "1. Set baseline file ; current set baseline $($baselineFilePath)" -ForegroundColor Green
    Write-Host "2. Add path to baseline" -ForegroundColor Green
    Write-Host "3. Check files against baseline" -ForegroundColor Green
    Write-Host "4. Check files against baseline with email" -ForegroundColor Green
    Write-Host "5. Create a new baseline" -ForegroundColor Green
    $entry=Read-Host -Prompt "Please enter a selection" 

    switch ($entry){
        "1"{
            $inputFilePick=New-Object System.Windows.Forms.OpenFileDialog
            $inputFilePick.Filter= "CSV (*.csv) | *.csv"
            $inputFilePick.ShowDialog()
            $baselineFilePath=$inputFilePick.FileName
            if(Test-Path -Path $baselineFilePath){
                if($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv"){

                }else{
                    $baselineFilePath=""
                    Write-Host "Invalid file needs to be a .csv" -ForegroundColor Red
                }
            }else{
                $baselineFilePath=""
                Write-Host "Invalid file path for baseline" -ForegroundColor Red
            }
        }
        "2"{
            $inputFilePick=New-Object System.Windows.Forms.OpenFileDialog
            $inputFilePick.ShowDialog()
            $targetFilePath=$inputFilePick.FileName
            Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath $targetFilePath
        }
        "3"{
            Verify-Baseline -baselineFilePath $baselineFilePath
        }
        "4"{
            $email=Read-Host -Prompt "Enter your email"
            Verify-Baseline -baselineFilePath $baselineFilePath -emailTo $email
        }
        "5"{
            $inputFilePick=New-Object System.Windows.Forms.SaveFileDialog
            $inputFilePick.Filter=$inputFilePick.Filter= "CSV (*.csv) | *.csv"
            $inputFilePick.ShowDialog()
            $newBaselineFilePath=$inputFilePick.FileName
            Create-Baseline -baselineFilePath $newBaselineFilePath
        }
        "q"{}
        "quit"{}
        default{
            Write-Host "Invalid entry" -ForegroundColor Red
        }
    }

}while($entry -notin @('q','quit'))


##create-Baseline -baselineFilePath $baselineFilePath

##Add-FileToBaseline -baselineFilePath $baselineFilePath -targetFilePath "C:\Users\Galvin\Desktop\BASICFILEMONITOR\files\test.txt"
#Verify-Baseline -baselineFilePath $baselineFilePath

#Verify-Baseline -baselineFilePath $baselineFilePath -emailTo "templargalvin@outlook.com"