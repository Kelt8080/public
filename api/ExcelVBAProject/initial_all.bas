Attribute VB_Name = "initial_all"
Option Explicit





Sub auto_open()

    Dim title_range, para_range, source_range, target_rang, fix_range As Range
    Dim i, j, k As Integer
    
    '�ݧ�s���e
    '����DB��s��ѫ�x�q�l���Ѷi��A�e�x�令�i��ʧ�s
    

    If WorksheetExists("����Ѽ�", ThisWorkbook) Then
    Set para_range = Workbooks(ThisWorkbook.name).Sheets("����Ѽ�").Range("A1:E500")
        For i = 1 To 500
            If para_range.Cells(i, 5).value = "�]�w�۰ʧ�s�A�}�Үɷ|�۰ʶפJ�̷s���" Then
                If para_range.Cells(i, 4).value = "�۰ʧ�s" Then
                    For j = 1 To 500
                        If para_range.Cells(j, 5).value = "�̷Ӥ��P��ƨӷ��榡�A�Ұʹ����{��" Then
                            Select Case para_range.Cells(j, 4).value
                                Case "db"
                                    Call report_menu_import_data
                                    Exit For
                                Case "api"
                                    Call report_menu_import_api
                                    Exit For
                                Case Else
                                    Call report_menu_import_data
                                    Exit For
                            End Select
                        End If
                    Next
                End If
            End If
        Next
        For i = 1 To 500
            If para_range.Cells(i, 5).value = "�����t��log" Then
                If para_range.Cells(i, 4).value = "Y" Then
                    'Call frm_rec_log_txt
                    Call frm_rec_log_googleforms
                    Exit For
                End If
            End If
        Next
    End If
    

    
End Sub



Sub report_menu_import_api()
'�U�ɮ�main�ҲտW�ߩI�s����ơA�b���ƥ��קK�{�����~

End Sub



Sub auto_close()

    Dim BackupPath As String
    Dim NowSheet As String
    Dim GetPivotTables As PivotTable
    Dim i, j, k As Integer
    Dim title_range, para_range, source_range, target_rang, fix_range As Range
    Dim focus_sheet As String
    
    
    
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    On Error Resume Next


    '�C�P�@10:30~14:30�Ұʳƥ�
    If Weekday(Date) = 2 Then
       If TimeValue(Time) >= TimeValue("10:30:00") And TimeValue(Time) <= TimeValue("14:30:00") Then
            '�i��ƥ��@�~
            BackupPath = "\\SolarDoc\�`�g�z��\�w���t�ȳB\�t�ȳ�\�t�ȳ��M��\14.�t�Ⱥ޲z�t��\WEA\�t�ȳ�����_�B���\�۰�Backup\" & ThisWorkbook.name
            If Dir(BackupPath) <> "" Then
                Kill BackupPath
            End If
            Workbooks(ThisWorkbook.name).SaveCopyAs (BackupPath)
        End If
    End If


    If Not ActiveWorkbook.ReadOnly Then
        'Call initial
        If WorksheetExists("����Ѽ�", ThisWorkbook) Then
        Set para_range = Workbooks(ThisWorkbook.name).Sheets("����Ѽ�").Range("A1:E500")
            For j = 1 To 500
                If para_range.Cells(j, 5).value = "�]�w�۰ʧ�s�A�}�Үɷ|�۰ʶפJ�̷s���" Then
                    If para_range.Cells(j, 4).value = "�۰ʧ�s" Then
                        NowSheet = ActiveSheet.name
                        Call del_unuse_row("db")
                        '��s�ϯä��R��
                        For i = 1 To Workbooks(ThisWorkbook.name).Sheets.Count
                            Set GetPivotTables = Workbooks(ThisWorkbook.name).Sheets(i).PivotTables(1)
                            If Not GetPivotTables Is Nothing Then
                                Workbooks(ThisWorkbook.name).Sheets(i).PivotTables(1).PivotCache.Refresh
                                GoTo exit_sub
                            End If
                        Next
exit_sub:
                        '�R���Ҧ�message
                        For i = 1 To Workbooks(ThisWorkbook.name).Sheets.Count
                            If Workbooks(ThisWorkbook.name).Sheets(i).name Like "*�Ѽ�*" Or Workbooks(ThisWorkbook.name).Sheets(i).name Like "*����*" Then
                            
                            Else
                                Workbooks(ThisWorkbook.name).Sheets(i).Cells.Validation.Delete
                            End If
                        Next
                        
                        Workbooks(ThisWorkbook.name).Activate
                        Workbooks(ThisWorkbook.name).Sheets(NowSheet).Select
                        Exit For
                    End If
                End If
            Next
        End If
        ThisWorkbook.Close SaveChanges:=True
    Else
        ThisWorkbook.Close SaveChanges:=False
    End If
    
    On Error GoTo 0
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    
End Sub




Sub timer_reset()

    Dim t As Long
    t = Timer   '�����e�ɶ�
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False



    Application.EnableEvents = True
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
    'MsgBox Format(Timer - t, "0.00") & "��"

         
End Sub


Function WorksheetExists(shtName As String, Optional wb As Workbook) As Boolean
    Dim sht As Worksheet

    If wb Is Nothing Then Set wb = ThisWorkbook
    On Error Resume Next
    Set sht = wb.Sheets(shtName)
    On Error GoTo 0
    WorksheetExists = Not sht Is Nothing
End Function


Function AlreadyOpen(strWorkBookName As String) As Boolean
    'Returns TRUE if the workbook is open
    Dim oXL As Excel.Application
    Dim oBk As Workbook

    On Error Resume Next
    Set oXL = GetObject(, "Excel.Application")
    If Err.Number <> 0 Then
        'Excel is NOT open, so the workbook cannot be open
        Err.Clear
        AlreadyOpen = False
    Else
        'Excel is open, check if workbook is open
        Set oBk = oXL.Workbooks(strWorkBookName)
        If oBk Is Nothing Then
            AlreadyOpen = False
        Else
            AlreadyOpen = True
            Set oBk = Nothing
        End If
    End If
    Set oXL = Nothing
End Function


Function FileFolderExists(strFullPath As String) As Boolean
    On Error GoTo EarlyExit
    If Not Dir(strFullPath, vbDirectory) = vbNullString Then FileFolderExists = True
EarlyExit:
    On Error GoTo 0
End Function


Function Offset_string(title_address, target_string As String) As String

    Dim para_range, source_range, target_rang As Range
    Dim source_cel, target_cel As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly, source_string As String
    Dim i, j, k As Integer

    '��l��
    Windows(ThisWorkbook.name).Activate
    Set source_range = Range(title_address)
    Set target_rang = ActiveCell
    LocalPath = Left(target_rang.Address, InStrRev(target_rang.Address, "$") - 1) & source_range.Cells(1).Row
    source_string = Range(LocalPath).value
    If WorksheetExists("����Ѽ�", ThisWorkbook) Then
        Set para_range = Workbooks(ThisWorkbook.name).Sheets("����Ѽ�").Range("A1:E500")
    End If
    
    
    If target_rang.Row > source_range.Cells(1).Row Then
        '�����o�{�����۹��m
        i = 1
        For Each source_cel In source_range.Cells
            If source_cel.value = "" Then Exit For
            If source_cel.value = source_string Then Exit For
            i = i + 1
        Next source_cel
        '���o"email���ϥγ��"�����-->email_email
        j = 1
        For Each source_cel In source_range.Cells
            If j = source_range.Cells.Count And source_cel.value <> target_string Then
                Offset_string = ""
                Exit For
            End If
            If source_cel.value = target_string Then
                k = j - i
                Offset_string = target_rang.Offset(0, k).value
                Exit For
            End If
            j = j + 1
        Next source_cel
    End If



End Function

Function Offset_string_auto(target_sheet, title_address, source_address, target_string As String) As String

    Dim para_range, source_range, target_rang As Range
    Dim source_cel, target_cel As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly, source_string As String
    Dim i, j, k As Integer


    '��l��
    Windows(ThisWorkbook.name).Activate
    Set source_range = Workbooks(ThisWorkbook.name).Sheets(target_sheet).Range(title_address)
    Set target_rang = Workbooks(ThisWorkbook.name).Sheets(target_sheet).Range(source_address)
    LocalPath = Left(target_rang.Address, InStrRev(target_rang.Address, "$") - 1) & source_range.Cells(1).Row
    source_string = Workbooks(ThisWorkbook.name).Sheets(target_sheet).Range(LocalPath).value
    If WorksheetExists("����Ѽ�", ThisWorkbook) Then
        Set para_range = Workbooks(ThisWorkbook.name).Sheets("����Ѽ�").Range("A1:E500")
    End If


    If target_rang.Row > source_range.Cells(1).Row Then
        '�����o�{�����۹��m
        i = 1
        For Each source_cel In source_range.Cells
            If source_cel.value = "" Then Exit For
            If source_cel.value = source_string Then Exit For
            i = i + 1
        Next source_cel
        '���o"email���ϥγ��"�����-->email_email
        j = 1
        For Each source_cel In source_range.Cells
            If j = source_range.Cells.Count And source_cel.value <> target_string Then
                Offset_string_auto = ""
                Exit For
            End If
            If source_cel.value = target_string Then
                k = j - i
                Offset_string_auto = target_rang.Offset(0, k).value
                Exit For
            End If
            j = j + 1
        Next source_cel
    End If
    


End Function




Sub frm_rec_log_googleforms()
    Dim last_row_1, last_row_2 As String
    Dim s_path, t_path As String
    Dim last_range, input_range As Range
    Dim FilePath, FileOnly, PathOnly, LocalPath, frm_basPath, CheckPath, UpperPath As String
    Dim fm, fso, aFile As Object
    Dim TestStr As String
    Dim strFolderName As String
    Dim strFolderExists As String
    Dim link(100), field(100), myURL, txt, str As String
    Dim myhttp As Object
    

    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    On Error Resume Next
    Application.Calculation = xlManual  '�����۰ʹB��
    

    Set fso = CreateObject("Scripting.FileSystemObject")
    FilePath = ThisWorkbook.FullName
    FileOnly = ThisWorkbook.name
    PathOnly = Left(FilePath, Len(FilePath) - Len(FileOnly))
    LocalPath = Left(PathOnly, InStrRev(PathOnly, "\") - 1)
    CheckPath = Right(LocalPath, Len(LocalPath) - InStrRev(LocalPath, "\"))
    UpperPath = Left(LocalPath, InStrRev(LocalPath, "\") - 1) & "\"


    '�ݭn��2��link
    link(1) = "https://docs.google.com/forms/d/e/1FAIpQLSeC9OyOC9Aqcxkgrwnr9d5ff9X_pEYZaAhG49QjJtPyZLCb6Q/formResponse?usp=pp_url&"
    link(2) = "https://docs.google.com/forms/d/e/1FAIpQLSeC9OyOC9Aqcxkgrwnr9d5ff9X_pEYZaAhG49QjJtPyZLCb6Q/viewform"
    Set myhttp = CreateObject("MSXML2.ServerXMLHTTP")
    'Set myhttp = CreateObject("WinHttp.WinHttpRequest.5.1")
    field(1) = "&entry.1286345521=" & Format(Now(), "yyyy/m/d h:mm;@")
    field(2) = "&entry.1224084617=" & Date
    field(3) = "&entry.807191636=" & URLEncode$(Application.UserName)
    field(4) = "&entry.750613553=" & URLEncode$(ThisWorkbook.name)
    field(5) = "&entry.1127642459=" & URLEncode$(ThisWorkbook.FullName)
    myURL = link(1) & field(1) & field(2) & field(3) & field(4) & field(5)
    myURL = myURL & "&submit=Submit"

    If Isurlvalid(link(2)) Then
        'myhttp.Open "POST", myURL, False
        myhttp.Open "GET", myURL, False
        'myhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        'myhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=Big5"
        myhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"
        'myhttp.setRequestHeader "Content-Type", "text/html; charset=Big5"
        'myhttp.setRequestHeader "Content-Type", "multipart/form-data; charset=UTF-8"
        'myhttp.setRequestHeader "enctype", "text/html; charset=UTF-8"
        myhttp.send
        'MsgBox convertraw(myhttp.responsebody)
    End If

    
    Application.Calculation = xlSemiautomatic   '���B��C��~�A�۰ʹB��
    On Error GoTo 0
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True


End Sub




Function Isurlvalid(ByVal url As String) As Boolean
    Dim myreq As Object

    Isurlvalid = False
    Set myreq = CreateObject("WinHttp.WinHttpRequest.5.1")
    
    If Not url Like "http*" Then
        url = "http://" & url
    End If
    
    On Error GoTo Notvalid
    
    With myreq
        .Open "GET", url, False
        .send
        If .Status = 200 Then Isurlvalid = True
        Exit Function
    End With
Notvalid:
End Function


Function URLEncode$(s$, Optional bForceOldSchool As Boolean)
  Select Case True
    Case bForceOldSchool Or Val(Application.Version) < 15
               URLEncode = CreateObject("htmlfile").parentWindow.encodeURIComponent(s)
    Case Else: URLEncode = WorksheetFunction.EncodeURL(s)
  End Select
End Function




Function convertraw(rawdata)

    Dim rawstr As Object
    Set rawstr = CreateObject("adodb.stream")
    With rawstr
        .Type = 1
        .Mode = 3
        .Open
        .Write rawdata
        .Position = 0
        .Type = 2
        .Charset = "big5"
        '.Charset = "UTF-8"
        convertraw = .ReadText
        .Close
    End With
    Set rawstr = Nothing

End Function




Sub frm_rec_log_txt()
    Dim last_row_1, last_row_2 As String
    Dim s_path, t_path As String
    Dim last_range, input_range As Range
    Dim FilePath, FileOnly, PathOnly, LocalPath, frm_basPath, CheckPath, UpperPath As String
    Dim fm, fso, aFile As Object
    Dim TestStr As String
    
    
    Application.EnableEvents = False
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    On Error Resume Next
    Application.Calculation = xlManual  '�����۰ʹB��


    Set fso = CreateObject("Scripting.FileSystemObject")
    FilePath = ThisWorkbook.FullName
    FileOnly = ThisWorkbook.name
    PathOnly = Left(FilePath, Len(FilePath) - Len(FileOnly))
    LocalPath = Left(PathOnly, InStrRev(PathOnly, "\") - 1)
    CheckPath = Right(LocalPath, Len(LocalPath) - InStrRev(LocalPath, "\"))
    UpperPath = Left(LocalPath, InStrRev(LocalPath, "\") - 1) & "\"
    s_path = UpperPath & "�t�ȳ�����_������\db\log_db.xlsb"
    t_path = "\\SolarDoc\Public\�t�ȳ����i\log\WEA\log_db.xlsb"
    
    '�}�ҭn�g�J��DB�A�p�G�䤣���ɮ״N�ƻs�@��
    TestStr = ""
    TestStr = Dir(t_path)
    If TestStr = "" Then
        'MsgBox "File doesn't exist"
        On Error GoTo EarlyExit
        fso.CopyFile s_path, t_path
EarlyExit:
    End If
    
    Workbooks.Open Filename:=t_path, ReadOnly:=False, IgnoreReadOnlyRecommended:=True, UpdateLinks:=False

    With Workbooks("log_DB.xlsb").Sheets("db")
        last_row_1 = .Cells(.Rows.Count, 1).End(xlUp).Row
        last_row_2 = last_row_1 + 1
        last_row_1 = last_row_1 & ":" & last_row_1
        last_row_2 = last_row_2 & ":" & last_row_2
        Set last_range = Range(last_row_1)
        Set input_range = Range(last_row_2)
        input_range.Cells(1).value = 1
        input_range.Cells(2).value = last_range.Cells(2).value + 1
        input_range.Cells(3).value = Now()
        input_range.Cells(4).value = Date
        input_range.Cells(5).value = Application.UserName
        'input_range.Cells(6).Value = Environ("UserName")
        input_range.Cells(6).value = FileOnly
    End With
    Workbooks("log_DB.xlsb").Close SaveChanges:=True
    

    Application.Calculation = xlSemiautomatic   '���B��C��~�A�۰ʹB��
    On Error GoTo 0
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True


End Sub




Function Paste_Columns(source_sheet, target_sheet As String)

    Dim source_range, target_rang As Range
    Dim source_cel, target_cel As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly As String
    
    '��l��
    Windows(ThisWorkbook.name).Activate
    Sheets(source_sheet).Select
    Set source_range = Range(Range("A1").End(xlToRight), Range("A1"))
    Sheets(target_sheet).Select
    Set target_rang = Range(Range("A1").End(xlToRight), Range("A1"))

    For Each target_cel In target_rang.Cells
        If target_cel.value = "" Then Exit For
        For Each source_cel In source_range.Cells
            If source_cel.value = "" Then Exit For
            If target_cel.value = source_cel.value Then
                PathOnly = source_cel.Address
                LocalPath = Left(PathOnly, InStrRev(PathOnly, "$") - 1)
                LocalPath = LocalPath & ":" & LocalPath
                Workbooks(ThisWorkbook.name).Sheets(source_sheet).Select
                Range(LocalPath).Select
                Selection.Copy
                Workbooks(ThisWorkbook.name).Sheets(target_sheet).Select
                Range(target_cel.Address).Select
                Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
            End If
        Next source_cel
    Next target_cel


End Function



Function Format_Columns()

    Dim source_range, target_rang As Range
    Dim source_cel, target_cel As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly As String
    
    ''��l��
    'Sheets(target_sheet).Select
    Set target_rang = Range(Range("A1").End(xlToRight), Range("A1"))

    For Each target_cel In target_rang.Cells
        PathOnly = target_cel.Address
        FilePath = Left(PathOnly, InStrRev(PathOnly, "$") - 1)
        LocalPath = FilePath & ":" & FilePath
        '�i���Ʈ榡��
        If target_cel.value Like "*��*" Or target_cel.value Like "*���*" Or target_cel.value Like "*Date*" Then
            Call Format_TextToColumns(target_cel.value)
            Range(LocalPath).NumberFormatLocal = "yyyy/m/d"
        ElseIf target_cel.value Like "*���*" Then
            Call Format_TextToColumns(target_cel.value)
            Range(LocalPath).NumberFormatLocal = "#,##0.000000_ ;[����]-#,##0.000000 "
        ElseIf target_cel.value Like "*�ƶq*" Or target_cel.value Like "*NTD*" Or target_cel.value Like "*�p�p*" Or target_cel.value Like "*�Z��*" Or target_cel.value Like "*KNT*" Or target_cel.value Like "*�Ѽ�*" Then
            Call Format_TextToColumns(target_cel.value)
            Range(LocalPath).NumberFormatLocal = "#,##0.0_ ;[����]-#,##0.0 "
        ElseIf target_cel.value Like "*Time*" Then
            Call Format_TextToColumns(target_cel.value)
            Range(LocalPath).NumberFormatLocal = "yyyy/m/d h:mm;@"
        ElseIf target_cel.value Like "*%*" Then
            Call Format_TextToColumns(target_cel.value)
            Range(LocalPath).NumberFormatLocal = "0%"
        ElseIf target_cel.value Like "*index*" Then
            Call Format_TextToColumns(target_cel.value)
        Else
            Range(LocalPath).NumberFormatLocal = "@"
        End If
    Next target_cel

End Function


Function Format_TextToColumns(target_text As String)


    Dim source_range, target_rang As Range
    Dim source_cel, target_cel As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly As String
    
    ''��l��
    Set target_rang = Range(Range("A1").End(xlToRight), Range("A1"))

    For Each target_cel In target_rang.Cells
        If target_cel.value = target_text Then
            PathOnly = target_cel.Address
            FilePath = Left(PathOnly, InStrRev(PathOnly, "$") - 1)
            LocalPath = FilePath & ":" & FilePath
            '�i���ƭ�R
            Columns(LocalPath).Select
            Selection.TextToColumns Destination:=Range(PathOnly), DataType:=xlDelimited, _
            TextQualifier:=xlDoubleQuote, ConsecutiveDelimiter:=False, Tab:=True, _
            Semicolon:=False, Comma:=False, Space:=False, Other:=False, FieldInfo _
            :=Array(1, 1), TrailingMinusNumbers:=True
        End If
    Next target_cel


End Function


Sub report_menu_Fullscreen()

    Dim wsSheet As Worksheet
    Dim NowSheet As String

    NowSheet = ActiveSheet.name
    
    Application.ScreenUpdating = False
    Application.ExecuteExcel4Macro "SHOW.TOOLBAR(""Ribbon"",False)"
    Application.DisplayFormulaBar = False
    Application.DisplayStatusBar = Not Application.DisplayStatusBar
    ActiveWindow.DisplayWorkbookTabs = True
    
    
    Application.ScreenUpdating = False
    For Each wsSheet In ThisWorkbook.Worksheets
        If Not wsSheet.name = "Blank" Then
            wsSheet.Activate
            With ActiveWindow
                .DisplayHeadings = False
                '.DisplayWorkbookTabs = True
                '.DisplayHorizontalScrollBar = False
            End With
        End If
    Next wsSheet

    Workbooks(ThisWorkbook.name).Activate
    Workbooks(ThisWorkbook.name).Sheets(NowSheet).Select
    Application.ScreenUpdating = True


End Sub

Sub report_menu_Deactivatescreen()

    Dim wsSheet As Worksheet
    Dim NowSheet As String

    NowSheet = ActiveSheet.name

    Application.ScreenUpdating = False
    Application.ExecuteExcel4Macro "SHOW.TOOLBAR(""Ribbon"",True)"
    Application.DisplayFormulaBar = True
    Application.DisplayStatusBar = True
    ActiveWindow.DisplayWorkbookTabs = True
    
    Application.ScreenUpdating = False
    For Each wsSheet In ThisWorkbook.Worksheets
        If Not wsSheet.name = "Blank" Then
            wsSheet.Activate
            With ActiveWindow
                .DisplayHeadings = True
                '.DisplayWorkbookTabs = True
                '.DisplayHorizontalScrollBar = True
            End With
        End If
    Next wsSheet

    Workbooks(ThisWorkbook.name).Activate
    Workbooks(ThisWorkbook.name).Sheets(NowSheet).Select
    Application.ScreenUpdating = True
    
End Sub



Sub report_menu_import_data()

    Dim NowSheet As String
    Dim GetPivotTables As PivotTable
    Dim i, j, k As Integer

    Workbooks(ThisWorkbook.name).Sheets("db").UsedRange.Offset(1).ClearContents
    

    On Error Resume Next
    Application.Calculation = xlManual  '�����۰ʹB��
    

        NowSheet = ActiveSheet.name
        Call import_data
        
        '��s�ϯä��R��
        For i = 1 To Workbooks(ThisWorkbook.name).Sheets.Count
            j = Workbooks(ThisWorkbook.name).Sheets.Count - i + 1
            Set GetPivotTables = Workbooks(ThisWorkbook.name).Sheets(j).PivotTables(1)
            If Not GetPivotTables Is Nothing Then
                Workbooks(ThisWorkbook.name).Sheets(j).PivotTables(1).PivotCache.Refresh
                GoTo exit_sub
            End If
        Next
    
exit_sub:
        Workbooks(ThisWorkbook.name).Activate
        Workbooks(ThisWorkbook.name).Sheets(NowSheet).Select
        
    On Error GoTo 0
    Application.Calculation = xlSemiautomatic   '���B��C��~�A�۰ʹB��

    
    
End Sub






Sub import_data()


    Dim title_range, para_range, source_range, target_rang, fix_range As Range
    Dim db_range, price_range, list_rang, category_rang As Range
    Dim LocalPath, FilePath, FileOnly, PathOnly As String
    Dim file_file(100), spath_file(100) As String
    Dim i, j, k As Integer
    Dim ws As Worksheet
    Dim fm, fso, aFile As Object
    Dim last_row_1 As String, last_column_1 As String, last_row_2 As String, last_column_2, last_row_3 As String, last_column_3 As String

    '��l��
    If WorksheetExists("����Ѽ�", ThisWorkbook) Then
        Set para_range = Workbooks(ThisWorkbook.name).Sheets("����Ѽ�").Range("A1:E500")
    End If
    Set fso = CreateObject("Scripting.FileSystemObject")
    FilePath = ThisWorkbook.FullName
    FileOnly = ThisWorkbook.name
    PathOnly = Left(FilePath, Len(FilePath) - Len(FileOnly))
    LocalPath = Left(PathOnly, InStrRev(PathOnly, "\") - 1)
    LocalPath = Left(LocalPath, InStrRev(LocalPath, "\") - 1)
    LocalPath = Left(LocalPath, InStrRev(LocalPath, "\") - 1)

    '�ѼƳ]�w�T�{
    For k = 1 To 500
        If para_range.Cells(k, 5).value = "�D���Ƽҫ���A�A�]�w�A�ݭn�����P��춶��" Then
            If para_range.Cells(k, 4).value = "" Then
                MsgBox "�A�S���]�w��Ƽҫ���C"
                Exit Sub
            Else
                Exit For
            End If
        End If
    Next
    For k = 1 To 500
        If para_range.Cells(k, 5).value = "�]�w�۰ʧ�s�A�}�Үɷ|�۰ʶפJ�̷s���" Then
            If para_range.Cells(k, 4).value = "" Then
                MsgBox "�A�S���]�w�O�_�۰ʧ�s��C"
                Exit Sub
            Else
                Exit For
            End If
        End If
    Next
    
    For k = 1 To 500
        If para_range.Cells(k, 5).value = "�D���Ƽҫ���A�A�]�w�A�ݭn�����P��춶��" Then
            file_file(1) = para_range.Cells(k, 4).value & ".xlsb"
            Exit For
        End If
    Next
    spath_file(1) = ThisWorkbook.Path & "\db\" & file_file(1)


    
    '�}�ҩҦ��ɮ�
    If FileFolderExists(spath_file(1)) Then
        Workbooks.Open Filename:=spath_file(1), Notify:=True, ReadOnly:=True, IgnoreReadOnlyRecommended:=True, UpdateLinks:=False
    Else
        MsgBox "�i" & spath_file(1) & "�j �ɮפ��s�b!"
    End If
    
    
    '��K��Ƽҫ�
    Workbooks(ThisWorkbook.name).Activate
    Workbooks(ThisWorkbook.name).Sheets("�R���ťզ�C").Cells.ClearContents
    Windows(file_file(1)).Activate
    Sheets("db").UsedRange.Copy
    Workbooks(ThisWorkbook.name).Activate
    Workbooks(ThisWorkbook.name).Sheets("�R���ťզ�C").Select
    Range("A1").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
    Range("A1").Copy
    Workbooks(file_file(1)).Close SaveChanges:=False
    Workbooks(ThisWorkbook.name).Activate
    Sheets("db").Select
    If ActiveSheet.AutoFilterMode Then
      Rows("1:1").AutoFilter
      Rows("1:1").AutoFilter
    Else
        Rows("1:1").AutoFilter
    End If
    Call Paste_Columns("�R���ťզ�C", "db")
    'Call Format_Columns
    Workbooks(ThisWorkbook.name).Sheets("�R���ťզ�C").Cells.ClearContents
    Sheets("db").Select
    Range("A1").Select
    
End Sub


Function del_all_row(target_sheet As String)

    Sheets(target_sheet).Select
    ActiveSheet.UsedRange.Select
    If ActiveSheet.UsedRange.Rows.Count > 2 Then
        Rows("3:" & ActiveSheet.UsedRange.Rows.Count).Select
        Selection.Delete Shift:=xlUp
        ActiveSheet.UsedRange.Select
        Selection.ClearContents
    Else
        ActiveSheet.UsedRange.Select
        Selection.ClearContents
    End If
    

End Function


Function del_unuse_row(target_sheet As String)


    Sheets(target_sheet).Select
    ActiveSheet.UsedRange.Select
    If ActiveSheet.UsedRange.Rows.Count > 2 Then
        Rows("3:" & ActiveSheet.UsedRange.Rows.Count).Select
        Selection.Delete Shift:=xlUp
    End If


End Function



Sub �޲z��_menu_update_message()
    Dim title_range, para_range, source_range, target_rang, fix_range As Range
    Dim focus_sheet, Response As String
    Dim i, j, k As Integer
    
    If WorksheetExists("�i�׻���", ThisWorkbook) Then
        Response = MsgBox("�A�n��s�i�׻�����?", vbYesNo)
        If Response = vbYes Then    ' User chose Yes.
            For j = 1 To Workbooks(ThisWorkbook.name).Sheets.Count
                If Workbooks(ThisWorkbook.name).Sheets(j).name Like "*�Ѽ�*" Or Workbooks(ThisWorkbook.name).Sheets(j).name Like "*����*" Then
                
                Else
                    Workbooks(ThisWorkbook.name).Sheets(j).Cells.Validation.Delete
                End If
            Next
            Call ini_message
            MsgBox "�i�׻����w�g�����е��C"
        End If
    Else
        MsgBox "�S��[�i�׻���]�����C"
    End If


End Sub


Sub report_menu_making()
        MsgBox "�o�@�ӥ\��γ����٦b�}�o���C"
End Sub


Sub no_meaasge()
        MsgBox "�o�@�����S���q������H�C"
End Sub


Function link_Folder_And_File(Source_Path As String)

    Dim strFolderName, strFolderExists As String
    
    strFolderName = Source_Path
    strFolderExists = Dir(strFolderName, vbDirectory)
    
    If strFolderExists = "" Then
        MsgBox "�ؿ����s�b�A���ˬd�ؿ����|�O�_���T�C"
        GoTo exit_sub
    Else
        Call Shell("explorer.exe " & strFolderName, vbNormalFocus)
    End If
exit_sub:
    
End Function

Function link_Excel_Report(Source_Path As String)

    Dim LocalPath, FilePath, FileOnly, PathOnly As String
    Dim strFileName, strFileName2, strFileExists As String

    FilePath = Source_Path
    LocalPath = Left(FilePath, InStrRev(FilePath, "\") + 1)
    FileOnly = Mid(FilePath, Len(LocalPath), Len(FilePath))
    strFileExists = Dir(FilePath)
    
    If strFileExists = "" Then
        MsgBox "�ɮפ��s�b�A���ˬd�ɮ׸��|�O�_���T�C"
        GoTo exit_sub
    Else
        If AlreadyOpen(CStr(FileOnly)) Then
            Windows(FileOnly).Activate
        Else
            Workbooks.Open Filename:=FilePath
            On Error Resume Next
            Application.Run "'" & FileOnly & "'!auto_open"
            On Error GoTo 0
        End If
    End If
exit_sub:


End Function


Function link_Web(ByVal link As String)
    'ActiveWorkbook.FollowHyperlink Address:=Source_Path, NewWindow:=True

   'Escape chars that cmd.exe uses
    link = Replace(link, "^", "^^")
    link = Replace(link, "|", "^|")
    link = Replace(link, "&", "^&")
    'Open default web browser
    Shell "CMD.EXE /C START " & link, vbHide
End Function
