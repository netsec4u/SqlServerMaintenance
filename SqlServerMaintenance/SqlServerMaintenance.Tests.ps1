Import-Module -Name PSScriptAnalyzer

describe 'Module-level tests' {

	it 'the module imports successfully' {
		{ Import-Module -Name "$PSScriptRoot\SQLServerMaintenance.psm1" -ErrorAction Stop } | should not throw
	}

	it 'the module has an associated manifest' {
		Test-Path "$PSScriptRoot\SQLServerMaintenance.psd1" | should Be $true
	}

	it 'passes all default PSScriptAnalyzer rules' {
		Invoke-ScriptAnalyzer -Path "$PSScriptRoot\SQLServerMaintenance.psm1" | should -BeNullOrEmpty
	}

}
