. $PSScriptRoot\Shared.ps1

Describe 'ParamsTabExpansion VSTS Tests' {
    Context 'Push Parameters TabExpansion Tests' {
        # Create a git alias for 'pr', as if we'd installed vsts-cli
        BeforeEach {
            [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssigments', '')]
            $origPath = Get-Location
            $temp = [System.IO.Path]::GetTempPath()
            $repoPath = Join-Path $temp ([IO.Path]::GetRandomFileName())

            &$gitbin init $repoPath
            Set-Location $repoPath

            &$gitbin config alias.pr "!f() { exec vsts code pr \`"`$`@\`"; }; f"
        }
        AfterEach {
            Set-Location $origPath
            if (Test-Path $repoPath) {
                Remove-Item $repoPath -Recurse -Force
            }
        }

        It 'Tab completes git pr create parameters values' {
            $result = & $module GitTabExpansionInternal 'git pr create --'
            $result -contains '--auto-complete' | Should Be $true
        }
        It 'Tab completes git pr create auto-complete parameters values' {
            $result = & $module GitTabExpansionInternal 'git pr create --auto-complete --'
            $result -contains '--delete-source-branch' | Should Be $true
        }
        It 'Tab completes git pr create all short push parameters' {
            $result = & $module GitTabExpansionInternal 'git pr create -'
            $result -contains '-d' | Should Be $true
            $result -contains '-i' | Should Be $true
            $result -contains '-p' | Should Be $true
            $result -contains '-r' | Should Be $true
            $result -contains '-s' | Should Be $true
            $result -contains '-h' | Should Be $true
            $result -contains '-o' | Should Be $true
        }
    }
}
