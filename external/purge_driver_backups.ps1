<#
origin: https://habrahabr.ru/post/319152/
#>

#[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('cp866')

#Checkpoint-Computer -Description "Driversdelete"

# получаем список драйверов
$temp = dism /online /get-drivers
$Lines = $temp | select -Skip 10

$Operation = "ItIsName"
$Drivers = @()

foreach ( $Line in $Lines ) {

    $temp1 = $Line
    $text = $($temp1.Split( ':' ))[1]

    switch ($Operation) {

        'ItIsName' { $Name = $text
                     $Operation = 'ItIsFileName'
                     break
                   }

        'ItIsFileName' { $FileName = $text.Trim()
                         $Operation = 'ItIsVhod'
                         break
                       }

        'ItIsVhod' { $Vhod = $text.Trim()
                     $Operation = 'ItIsClassName'
                     break
                   }

        'ItIsClassName' { $ClassName = $text.Trim()
                          $Operation = 'ItIsVendor'
                          break
                        }

        'ItIsVendor' { $Vendor = $text.Trim()
                       $Operation = 'ItIsDate'
                       break
                     }

        'ItIsDate' { # переводим дату в европейский стандарт, чтобы сортировать
                     $tmp = $text.split( '.' )
                     $text = "$($tmp[2]).$($tmp[1]).$($tmp[0].Trim())"
                     $Date = $text
                     $Operation = 'ItIsVersion'
                     break
                   }

        'ItIsVersion' { $Version = $text.Trim()
                        $Operation = 'ItIsNull'

                        $params = [ordered]@{ 'FileName' = $FileName
                                              'Vendor' = $Vendor
                                              'Date' = $Date
                                              'Name' = $Name
                                              'ClassName' = $ClassName
                                              'Version' = $Version
                                              'Vhod' = $Vhod
                                            }
    
                        $obj = New-Object -TypeName PSObject -Property $params
                        $Drivers += $obj

                        break
                      }

         'ItIsNull' { $Operation = 'ItIsName'
                      break
                     }

    }
}

Write-Host 'All drivers' -ForegroundColor Yellow
Write-Host '-------------------' -ForegroundColor Yellow
$Drivers | sort Filename | format-table -autosize



Write-Host 'Drivers with multiple versions' -ForegroundColor Yellow
Write-Host '-------------------' -ForegroundColor Yellow

$last = ''
$NotUnique = @()

foreach ( $Dr in $($Drivers | sort Filename) ) {
    
    if ($Dr.FileName -eq $last  ) {  $NotUnique += $Dr  }
    $last = $Dr.FileName
}

$NotUnique | sort FileName | format-table -autosize



Write-Host 'Backup/obsolete driver versions' -ForegroundColor Yellow
Write-Host '-------------------' -ForegroundColor Yellow
$list = $NotUnique | select -ExpandProperty FileName -Unique

$ToDel = @()
foreach ( $Dr in $list ) {
    Write-Host 'Found dup' -ForegroundColor Yellow
    $sel = $Drivers | where { $_.FileName -eq $Dr } | sort date -Descending | select -Skip 1
    $sel | format-table -autosize

    $ToDel += $sel
}

Write-Host 'Candidates for deletion' -ForegroundColor Green
Write-Host '-------------------' -ForegroundColor Green

$ToDel | format-table -autosize

foreach ( $item in $ToDel ) {
    $Name = $($item.Name).Trim()

    Write-Host ' ' -ForegroundColor Green
    Write-Host "Removing ${Name}" -ForegroundColor Green
    Write-Host "pnputil.exe -d ${Name}" -ForegroundColor Green
    Invoke-Expression -Command "pnputil.exe -d ${Name}"
}