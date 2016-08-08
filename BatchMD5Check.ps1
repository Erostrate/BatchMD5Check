<#
��������FILES�ļ������ļ���MD5ֵ
�汾v1.0:����
#>

#��������
$Dirs="FILES"
$ResultFile="ResultFile.txt"
$TotalFiles=0

#����
Function FormatPath($FullPath)
{
	$Count=0
	[System.Collections.ArrayList]$SplitedPath=$FullPath -split '\\'
	ForEach($Temp in $SplitedPath)
	{
		If($Temp -ne $Dirs)
		{
			$Count+=1
		}
		Else
		{
			Break
		}
	}
	$SplitedPath.RemoveRange(0,$Count)
	return $SplitedPath -join '\'
}

#�����ͳ�Ƶ��ļ�����
Get-ChildItem $Dirs -recurse | ForEach-Object {
	If($_ -is [System.IO.FileInfo])
	{
		$TotalFiles+=1
	}
}

#����FILES�ļ��в����μ����ļ���MD5
$i=1
Out-File -Encoding "Unicode" $ResultFile
Get-ChildItem $Dirs -recurse | ForEach-Object {
	If($_ -is [System.IO.FileInfo])
	{
		Clear
		Write-Output "Computing MD5...${i}/${TotalFiles}"
		$FormattedPath=FormatPath $_.fullname
		$MD5Value=(CertUtil -hashfile $FormattedPath MD5)[1]
		Write-Output "${FormattedPath}`t${MD5Value}" | Out-File -Append -Encoding "Unicode" $ResultFile
		$i+=1
	}
}
Write-Output "Completed"
cmd /c "pause"