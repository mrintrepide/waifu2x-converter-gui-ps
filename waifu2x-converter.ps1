Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName WindowsFormsIntegration

function OpenFile() {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $DefaultPath
    [void]$OpenFileDialog.ShowDialog()
    $OpenFileDialog.FileName
}

function SaveFile() {
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.InitialDirectory = $DefaultPath
    [void]$SaveFileDialog.ShowDialog()
    $SaveFileDialog.FileName
}

function Engine($InputFile, $OutputFile, $Mode, $NoiseLevel, $ScaleRatio, $BlockSize) {
    $ModeArray = "noise_scale", "noise", "scale"
    $NoiseLevelArray = 1, 2, 3
    $ScaleRatioArray = 2.0, 4.0, 8.0, 16.0
    $BlockSizeArray = 0, 512, 1024, 2048
    Start-Process -FilePath "waifu2x-converter-cpp\waifu2x-converter-cpp.exe" -ArgumentList "-i $($InputFile) -o $($OutputFile) -m $($ModeArray[$Mode]) --noise_level $($NoiseLevelArray[$NoiseLevel]) --scale_ratio $($ScaleRatioArray[$ScaleRatio]) --block_size $($BlockSizeArray[$BlockSize]) --model_dir waifu2x-converter-cpp\models_rgb"
}

$MainWindow = New-Object Windows.Window
$MainWindow.Title = "Waifu2x Converter - PowerShell GUI"
$MainWindow.Width = 600
$MainWindow.Height = 250
$MainWindow.ResizeMode = "CanMinimize"

$MainGrid = New-Object Windows.Controls.Grid
$FirstRow = New-Object Windows.Controls.RowDefinition
$FirstRow.Height = 30
$MainGrid.RowDefinitions.Add($FirstRow)
$SecondRow = New-Object Windows.Controls.RowDefinition
$SecondRow.Height = 30
$MainGrid.RowDefinitions.Add($SecondRow)
$ThirdRow = New-Object Windows.Controls.RowDefinition
$ThirdRow.Height = 30
$MainGrid.RowDefinitions.Add($ThirdRow)
$FourthRow = New-Object Windows.Controls.RowDefinition
$FourthRow.Height = 30
$MainGrid.RowDefinitions.Add($FourthRow)
$MainWindow.Content = $MainGrid

$InputLabel = New-Object Windows.Controls.Label
$InputLabel.SetValue([Windows.Controls.Grid]::RowProperty, 0)
$InputLabel.HorizontalAlignment = "Left"
$InputLabel.Margin = "10,6,0,0"
$InputLabel.Content = "Input Path"
$MainGrid.AddChild($InputLabel)

$InputTextBox = New-Object Windows.Controls.TextBox
$InputTextBox.SetValue([Windows.Controls.Grid]::RowProperty, 0)
$InputTextBox.HorizontalAlignment = "Stretch"
$InputTextBox.Margin = "90,10,90,0"
$MainGrid.AddChild($InputTextBox)

$InputButton = New-Object Windows.Controls.Button
$InputButton.SetValue([Windows.Controls.Grid]::RowProperty, 0)
$InputButton.HorizontalAlignment = "Right"
$InputButton.Margin = "0,10,10,0"
$InputButton.Content = "Browse"
$InputButton.Width = 70
$InputButton.Add_Click({
    $Path = OpenFile
    if ($Path -ne "") {
        $InputTextBox.Text = $Path
        $OutputTextBox.Text = ([io.fileinfo]$Path).DirectoryName + "\" + ([io.fileinfo]$Path).BaseName + "_out.png"
    }
})
$MainGrid.AddChild($InputButton)

$OutputLabel = New-Object Windows.Controls.Label
$OutputLabel.SetValue([Windows.Controls.Grid]::RowProperty, 1)
$OutputLabel.HorizontalAlignment = "Left"
$OutputLabel.Margin = "10,6,0,0"
$OutputLabel.Content = "Output Path"
$MainGrid.AddChild($OutputLabel)

$OutputTextBox = New-Object Windows.Controls.TextBox
$OutputTextBox.SetValue([Windows.Controls.Grid]::RowProperty, 1)
$OutputTextBox.HorizontalAlignment = "Stretch"
$OutputTextBox.Margin = "90,10,90,0"
$MainGrid.AddChild($OutputTextBox)

$OutputButton = New-Object Windows.Controls.Button
$OutputButton.SetValue([Windows.Controls.Grid]::RowProperty, 1)
$OutputButton.HorizontalAlignment = "Right"
$OutputButton.Margin = "0,10,10,0"
$OutputButton.Content = "Browse"
$OutputButton.Width = 70
$OutputButton.Add_Click({
    $Path = SaveFile
    if ($Path -ne "") {
        $OutputTextBox.Text = $Path
    }
})
$MainGrid.AddChild($OutputButton)

$ModeLabel = New-Object Windows.Controls.Label
$ModeLabel.SetValue([Windows.Controls.Grid]::RowProperty, 2)
$ModeLabel.HorizontalAlignment = "Left"
$ModeLabel.Margin = "10,6,0,0"
$ModeLabel.Content = "Waifu2x Mode"
$MainGrid.AddChild($ModeLabel)

$ModeComboBox = New-Object Windows.Controls.ComboBox
$ModeComboBox.SetValue([Windows.Controls.Grid]::RowProperty, 3)
$ModeComboBox.HorizontalAlignment = "Left"
$ModeComboBox.Margin = "10,0,0,10"
$ModeComboBox.Width = 130
[void]$ModeComboBox.Items.Add("Denoise & Upscale")
[void]$ModeComboBox.Items.Add("Deoise Only")
[void]$ModeComboBox.Items.Add("Upscale Only")
$ModeComboBox.SelectedIndex = 0
$MainGrid.AddChild($ModeComboBox)

$NoiseLevelLabel = New-Object Windows.Controls.Label
$NoiseLevelLabel.SetValue([Windows.Controls.Grid]::RowProperty, 2)
$NoiseLevelLabel.HorizontalAlignment = "Left"
$NoiseLevelLabel.Margin = "150,6,0,0"
$NoiseLevelLabel.Content = "Denoise Level"
$MainGrid.AddChild($NoiseLevelLabel)

$NoiseLevelComboBox = New-Object Windows.Controls.ComboBox
$NoiseLevelComboBox.SetValue([Windows.Controls.Grid]::RowProperty, 3)
$NoiseLevelComboBox.HorizontalAlignment = "Left"
$NoiseLevelComboBox.Margin = "150,0,0,10"
$NoiseLevelComboBox.Width = 100
[void]$NoiseLevelComboBox.Items.Add("Level 1")
[void]$NoiseLevelComboBox.Items.Add("Level 2")
[void]$NoiseLevelComboBox.Items.Add("Level 3")
$NoiseLevelComboBox.SelectedIndex = 0
$MainGrid.AddChild($NoiseLevelComboBox)

$ScaleRatioLabel = New-Object Windows.Controls.Label
$ScaleRatioLabel.SetValue([Windows.Controls.Grid]::RowProperty, 2)
$ScaleRatioLabel.HorizontalAlignment = "Left"
$ScaleRatioLabel.Margin = "260,6,0,0"
$ScaleRatioLabel.Content = "Scale Ratio"
$MainGrid.AddChild($ScaleRatioLabel)

$ScaleRatioComboBox = New-Object Windows.Controls.ComboBox
$ScaleRatioComboBox.SetValue([Windows.Controls.Grid]::RowProperty, 3)
$ScaleRatioComboBox.HorizontalAlignment = "Left"
$ScaleRatioComboBox.Margin = "260,0,0,10"
$ScaleRatioComboBox.Width = 80
[void]$ScaleRatioComboBox.Items.Add("x2.0")
[void]$ScaleRatioComboBox.Items.Add("x4.0")
[void]$ScaleRatioComboBox.Items.Add("x8.0")
[void]$ScaleRatioComboBox.Items.Add("x16.0")
$ScaleRatioComboBox.SelectedIndex = 0
$MainGrid.AddChild($ScaleRatioComboBox)

$BlockSizeLabel = New-Object Windows.Controls.Label
$BlockSizeLabel.SetValue([Windows.Controls.Grid]::RowProperty, 2)
$BlockSizeLabel.HorizontalAlignment = "Left"
$BlockSizeLabel.Margin = "350,6,0,0"
$BlockSizeLabel.Content = "Block Size"
$MainGrid.AddChild($BlockSizeLabel)

$BlockSizeComboBox = New-Object Windows.Controls.ComboBox
$BlockSizeComboBox.SetValue([Windows.Controls.Grid]::RowProperty, 3)
$BlockSizeComboBox.HorizontalAlignment = "Left"
$BlockSizeComboBox.Margin = "350,0,0,10"
$BlockSizeComboBox.Width = 80
[void]$BlockSizeComboBox.Items.Add("0")
[void]$BlockSizeComboBox.Items.Add("512")
[void]$BlockSizeComboBox.Items.Add("1024")
[void]$BlockSizeComboBox.Items.Add("2048")
$BlockSizeComboBox.SelectedIndex = 1
$MainGrid.AddChild($BlockSizeComboBox)

$StartButton = New-Object Windows.Controls.Button
$StartButton.SetValue([Windows.Controls.Grid]::RowProperty, 3)
$StartButton.HorizontalAlignment = "Right"
$StartButton.Margin = "0,0,10,10"
$StartButton.Content = "Start"
$StartButton.Width = 70
$StartButton.Add_Click({
    Engine $InputTextBox.Text $OutputTextBox.Text $ModeComboBox.SelectedIndex $NoiseLevelComboBox.SelectedIndex $ScaleRatioComboBox.SelectedIndex $BlockSizeComboBox.SelectedIndex
})
$MainGrid.AddChild($StartButton)

[void]$MainWindow.ShowDialog()
