Attribute VB_Name = "dbgShellEx"
Option Compare Database
Option Explicit

Private Declare Function apiShellExecute Lib "shell32.dll" _
    Alias "ShellExecuteA" _
    (ByVal hWnd As Long, _
    ByVal lpOperation As String, _
    ByVal lpFile As String, _
    ByVal lpParameters As String, _
    ByVal lpDirectory As String, _
    ByVal nShowCmd As Long) _
    As Long

'ShowWindow Enum
Public Enum eSE_ShowWindow
  seswHide = 0
  seswNormal = 1
  seswShowMinimized = 2
  seswShowMaximized = 3
  seswShowNoActivate = 4
  seswShow = 5
  seswMinimize = 6
  seswShowMinNoActive = 7
  seswShowNA = 8
  seswRestore = 9
  seswShowDefault = 10
  seswForceMinimize = 11
  seswMax = 12
End Enum


'Operation enum
Public Enum eSE_Operation
  seopDefault = -1
  seopOpen = 0
  seopPrint = 1
  seopExplore = 2
  seopRead = 3
  seopProperties = 4
End Enum

'============================================================================
' NAME: ShellEx
' DESC: Calls ShellExecute API
'============================================================================
'ErrStrV3.00
Public Function ShellEx( _
  sFile As String, _
  Optional iOperation As eSE_Operation = seopDefault, _
  Optional sParameters As String = "", _
  Optional sDirectory As String = "", _
  Optional lShowCmd As eSE_ShowWindow = seswNormal, _
  Optional lHand As Long = 0 _
  ) As Boolean
On Error GoTo Error_Proc
Dim Ret As Boolean
'=========================
  Dim sOp As String
'=========================

  Select Case iOperation
    Case seopOpen: sOp = "open"
    Case seopPrint: sOp = "print"
    Case seopExplore: sOp = "explore"
    Case seopRead: sOp = "read"
    Case seopDefault: sOp = vbNullChar
    Case seopProperties: sOp = "properties"
    Case Else: sOp = vbNullChar
  End Select
  
  If Len(sParameters) = 0 Then sParameters = vbNullString
  If Len(sDirectory) = 0 Then sDirectory = vbNullString
  
  Ret = IIf(apiShellExecute(lHand, sOp, sFile, sParameters, sDirectory, lShowCmd) > 32, True, False)
  
'=========================
Exit_Proc:
  ShellEx = Ret
  Exit Function
Error_Proc:
  MsgBox "Error: " & Trim(Str(Err.Number)) & vbCrLf & _
    "Desc: " & Err.Description & vbCrLf & vbCrLf & _
    "Module: basShellExecute, Procedure: ShellEx" _
    , vbCritical, "Error!"
  Resume Exit_Proc
  Resume

End Function




