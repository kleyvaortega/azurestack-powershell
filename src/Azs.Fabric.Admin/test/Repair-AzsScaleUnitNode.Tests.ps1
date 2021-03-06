$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)
$TestRecordingFile = Join-Path $PSScriptRoot 'Repair-AzsScaleUnitNode.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'Repair-AzsScaleUnitNode' {
    . $PSScriptRoot\Common.ps1
	
	BeforeEach {
	}
	
	AfterEach {
        $global:Client = $null
    }

    It 'RepairSacleUnit' -skip:$('RepairSacleUnit' -in $global:SkippedTests) {
        { 
		    $global:TestName = 'RepairSacleUnit'

            $ScaleUnitNodes = Get-AzsScaleUnitNode -ResourceGroupName $global:ResourceGroupName -Location $global:Location
            $ScaleUnitNodes | Should Not Be $null
			
			Repair-AzsScaleUnitNode -Name $ScaleUnitNodes[0].Name -ResourceGroupName $global:ResourceGroupName -Location $global:Location -Force
		} | Should Throw
    }
}
