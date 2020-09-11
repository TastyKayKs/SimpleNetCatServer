$Body = @'
<link rel="icon" href="data:,">
<html>
<body>
Hey guys, whatup!
</body>
</html>
'@

$Header = 'HTTP/1.1 200 OK
Content-Length: '+$Body.Length+'
Connection: close
Content-Type: text/html; charset=utf-8

'

$SrvResp = [System.Text.Encoding]::UTF8.GetBytes(($Header+$Body))

$Listener = (New-Object System.Net.Sockets.TCPListener -ArgumentList @("0.0.0.0",55555))
$Listener.Start()

While($True){
	Write-Host "Listening for connection..." -ForeGround Yellow -BackGround Black
	
	$Connection = $Listener.AcceptTcpClient()
	
	Write-Host "Got connection!" -ForeGround Yellow -BackGround Black
	
	$Stream = $Connection.GetStream()
	
	$CliReqStr = ""
	While($Stream.DataAvailable){
		Write-Host "Reading in 1024 bytes!" -ForeGround Yellow -BackGround Black
	
		$CliReq = (New-Object Byte[] 1024)	
		[Void]$Stream.Read($CliReq,0,1024)
		$CliReqStr+=[System.Text.Encoding]::UTF8.GetString($CliReq)
	
		Sleep -Milliseconds 100
	}
	
	Write-Host "These were the incoming bytes converted to a string:" -ForeGround Yellow -BackGround Black
	Write-Host $CliReqStr

	Write-Host "Sending webpage..." -ForeGround Yellow -BackGround Black

	$Stream.Write($SrvResp,0,$SrvResp.Length)
	
	Write-Host "Done!" -ForeGround Yellow -BackGround Black
}
