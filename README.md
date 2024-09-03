<h1>File Integrity Monitor</h1>



<h2>Description</h2>
Following along with a tutorial, I created a PS script to create a file integrity monitor.
<br />


<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 
- <b>Microsoft SQL Server </b>
 

<h2>Environments Used </h2>

- <b>Windows 11</b> 
- <b>VS Code</b> 

<h2>Program walk-through:</h2>

<p align="center">
Download Windows10 and Windows Sever ISO's, and Use this network diagram for refference: <br/>
<br/>
<img src="https://i.imgur.com/R1QJevx.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Open VirtualBox and create the first virtual machine(Domain Controller):  <br/>
<img src="https://i.imgur.com/LOQxmCN.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
If possible, allocate 4GB of RAM and 4 proccessors to Domain Controller: <br/>
<img src="https://i.imgur.com/fKP4HyQ.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Go to settings, select network, and give the Domain Controller two NIC's. Adapter 1 for NAT and Adapter 2 for internal network:  <br/>
<img src="https://i.imgur.com/uNaAB7C.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
 <img src="https://i.imgur.com/Ldnwm8w.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
Run Domain Controller and install Windows Server desktop experience:  <br/>
<img src="https://i.imgur.com/UGUlyZZ.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Open Network Connections and label network connections accordingly (internet and external):  <br/>
<img src="https://i.imgur.com/5kr7ceB.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Assign IP address for internal network(refer to network diagram):  <br/>
<img src="https://i.imgur.com/0lmLJvp.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Rename this PC by right clocking start button, and clicking system:  <br/>
<img src="https://i.imgur.com/1GUKRKf.jpeg" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Install active directory domain services: <br/>
<img src="https://i.imgur.com/N2TSLEe.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Promote the server to a domain controller:  <br/>
<img src="https://i.imgur.com/QpnVDqv.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Create orginizational unit via AD users and computers, and label it _admins. Right click _admins, go to new, select users and create an admin user(a-gtemplar). Right click the user, go to member of, click add and enter Domain Admins:  <br/>
<img src="https://i.imgur.com/gHANDu1.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Sign out and sign in with new admin account:  <br/>
<br />
<br />
Install RAS/NAT to allow the client to access the internet through our private virtual network:  <br/>
Install remote access and routing:  <br/>
<img src="https://i.imgur.com/qURgVzd.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Go to tools, go to routing and remote access, and install NAT on the internet NIC: <br/>
<img src="https://i.imgur.com/qURgVzd.png" height="80%](https://i.imgur.com/qURgVzd.png)" width="80%" alt="Disk Sanitization Steps"/>
<br />
<img src="https://i.imgur.com/mTgyrgR.png" height="80%](https://i.imgur.com/qURgVzd.png)" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Install a DHCP server on our domain controller to allow the client computer to obtain an IP address:  <br/>
<img src="https://i.imgur.com/3kcRpww.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Assign scope of 172.16.0.100-200 to the IPv4 in the DHCP menu:  <br/>
<img src="https://i.imgur.com/yGL5atT.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
There will be no exclusions for this case, and we will set the default gateway to 172.16.0.1(domain controller IP address):  <br/>
<img src="https://i.imgur.com/UNvKycU.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Right click DHCP server, click authorize, and refresh: <br/>
<br />
<br />
Use Powershell to configure multiple users on the network:  <br/>
<img src="https://i.imgur.com/Zw4D4b7.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Create Windows 10 VM following same steps used to create DomainController. Log in to Windows 10 client and use ipconfig in command prompt to confirm internet connection  <br/>
<img src="https://i.imgur.com/6fqmrxn.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Rename computer and join domain  <br/>
<img src="https://i.imgur.com/4QPLv6p.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
Ping google to confirm that our Client is connecting to the default gateway, and that the domain controller is properly translating to the internet.
<img src="https://i.imgur.com/YiKe9ZU.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>


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
