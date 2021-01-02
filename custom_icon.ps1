# https://onlineimagetools.com/convert-image-to-base64
# online image ico to base64 converter 
# https://icons.iconarchive.com/icons/scafer31000/bubble-circle-2/16/Message-icon.png

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$f = New-Object System.Windows.Forms.Form
$f.Size = New-Object System.Drawing.Size(160,130)
$f.Text = 'dummy'
$f.AutoSize = $false
$f.MaximizeBox = $false
$f.MinimizeBox = $true
$f.BackColor = '#c08888'
$f.ShowIcon = $true 
$f.SizeGripStyle = [System.Windows.Forms.SizeGripStyle]::Hide
$f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$f.WindowState = 'Normal'
$f.StartPosition = 'CenterScreen' 
$f.Opacity = 1.0
$f.TopMost = $false

$f.Font = 'Microsoft Sans Serif,10'
$f.MaximizeBox = $false

$iconBase64 = 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAC+UlEQVR42nVTW0hUURRd59x5OflitKFifKQflTpWpmJjidqDMqyP6OVHUB8WalFC9BEkFBVESaGW+FFQaBRUEKVBNMSYY9YUouhUSg5jmelgcnOa173ndueKlmULDhw2e6+z1t77EPwF08Z95uRtB8oN6WuLKaXJIIAkwfV9oNc69KCuafhZc++f+WTmEmFM1GafbqlNSTMfTtAJlMkxiVMp1RBCSqLLr2HDH/saHWfKqn2jrsAsgc6YoLVcsbXmJMYW+zkthnwqzIdUXRAs4Efv6JS181hhie+bK6AQ5Na2NxTmZFaMiDpMBGdFIUo9LWBK+E2yUMMQzbx43fPhWtcxSyUxFuwxbzx1sztGR+ngFIWGA/amUmwxUcRpp8nG/RLahhnufWIIyd5WRIXg5iXWeenQKpJR87SudFNBld2jgooCly0cMg0UhPxr4d04w4lOEaKsKjc2gKe2rnqSe5vvW5+gTrOPq7BjKcHJNRz+h7Cd829FPHFJyIsLoOMr+onlTsBrNkh6h4dDTR5FaQrFRYcIg46AyQV8UEJiFEGvR8JZWd3DQYZzrxksxhDs39Q/Sc6toDfDIOgd42pUraYoX0kx/ENSeqFMUPYcoQoTAUtjCK53M+WsWxzCy1GZYFkD31eQSNNsI1osigQe7eQQrSXzWpiUm7n9vogxL1BoEvDCLfaTJUfb6rYW5VdZv0QoSRkLgbrNHJJi55IMTEg4/kxEv0fpBjYlCXj8vKOe6LN2mbOONHfrmJ86eb2yWRc2ELgnAZ8QTgWcsv83I1B6EkaOMYDPPg1zNu5fpTwTf9TWUJSXVdE3BniCOnDyOEU2/yRMC4JINhDYXr275rmaX6kQ0BiT1lDZ3rpueXyxhw+hn4+eb4jIivNCr9fA/n7MOtFQUMIm3YFZo2GSqLKW2qT0vMOpep4KjCgqiLxRYUUaFYGTj2SfnV2NP1rKqsPFc37jDDTm3WZN9sFyVVJ+MVVHJIdjLORzCW67Nei40RTsuTvnO/8Cl+E5Sa72joAAAAAASUVORK5CYII=' 
$iconBytes = [Convert]::FromBase64String($iconBase64)
$stream = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage = [System.Drawing.Image]::FromStream($stream, $true)
$f.Icon = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

[void]$f.ShowDialog()
$f.Dispose()
