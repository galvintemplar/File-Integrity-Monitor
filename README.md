<h1>File Integrity Monitor</h1>

<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 
- <b>Microsoft SQL Server</b>
- <b>XML</b>
- <b>Mailkit</b>
- <b>Mimekit</b>

 

<h2>Environments Used </h2>

- <b>Windows 11</b> 
- <b>VS Code</b> 


<h2>Overview</h2>



This PowerShell script is designed for effective file monitoring by managing a baseline of file paths and their corresponding hashes. It facilitates the following functionalities:

- Adding files to a baseline.
- Verifying file integrity against the baseline.
- Creating new baseline files.
- Sending email notifications when file changes are detected.

## Script Components

1. **Module and Assembly Imports**
   - The script imports an external module for email functionality and loads the `System.Windows.Forms` assembly for user interface dialogs:
     ```powershell
     Import-Module "C:\Users\Galvin\Desktop\BASICFILEMONITOR\Scripts\mail.ps1"
     Add-Type -AssemblyName System.Windows.Forms
     ```

2. **Configuration Variables**
   - Email-related configuration variables are defined:
     - `$EmailCredentialsPath`: Path to the XML file containing email credentials.
     - `$EmailServer`: SMTP server address (e.g., `smtp-mail.outlook.com`).
     - `$EmailPort`: SMTP port (e.g., `587`).

## Functions

### `Add-FileToBaseline`

- **Purpose**: Adds or updates a file path and its hash in a baseline CSV file.
- **Parameters**:
  - `$baselineFilePath`: Path to the CSV file serving as the baseline.
  - `$targetFilePath`: Path to the file to be added.
- **Functionality**:
  - Validates the existence of both the baseline CSV and the target file.
  - Ensures the baseline file is in CSV format.
  - Prompts the user to confirm overwriting an existing entry if the file path is already present.
  - Updates or adds the file path and hash to the CSV based on user input.

### `Verify-Baseline`

- **Purpose**: Verifies the integrity of files listed in the baseline CSV.
- **Parameters**:
  - `$baselineFilePath`: Path to the CSV file used as the baseline.
  - `$emailTo` (optional): Email address for notifications.
- **Functionality**:
  - Checks if files listed in the baseline are present.
  - Compares the current hash of each file with the recorded hash.
  - Sends an email notification if a file’s hash has changed and an email address is provided.

### `Create-Baseline`

- **Purpose**: Creates a new baseline CSV file.
- **Parameters**:
  - `$baselineFilePath`: Path to the new CSV file.
- **Functionality**:
  - Generates a new CSV file with headers "path,hash".

## User Interface

The script offers a straightforward command-line menu with the following options:

1. **Set Baseline File**: Select and configure the baseline CSV file.
2. **Add Path to Baseline**: Include a file path and its hash in the baseline.
3. **Check Files Against Baseline**: Validate file hashes against the baseline.
4. **Check Files and Send Email Notifications**: Verify file hashes and send email alerts if discrepancies are detected.
5. **Create a New Baseline**: Establish a new baseline CSV file.

Windows Forms dialogs facilitate file selection, and the script interacts with users via console prompts.

## Error Handling

The script includes comprehensive error handling to manage scenarios such as missing files or incorrect file formats, providing clear and informative error messages.

## Summary

In summary, this script efficiently tracks file changes by maintaining a baseline of file paths and their hashes. It allows for baseline updates, file integrity verification, and optional email notifications for any detected changes.







</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
