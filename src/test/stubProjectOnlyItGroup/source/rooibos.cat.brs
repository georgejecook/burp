' VERSION: Rooibos 0.1.0
' LICENSE: MIT License
' LICENSE: 
' LICENSE: Copyright (c) 2018 
' LICENSE: 
' LICENSE: Permission is hereby granted, free of charge, to any person obtaining a copy
' LICENSE: of this software and associated documentation files (the "Software"), to deal
' LICENSE: in the Software without restriction, including without limitation the rights
' LICENSE: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' LICENSE: copies of the Software, and to permit persons to whom the Software is
' LICENSE: furnished to do so, subject to the following conditions:
' LICENSE: 
' LICENSE: The above copyright notice and this permission notice shall be included in all
' LICENSE: copies or substantial portions of the Software.
' LICENSE: 
' LICENSE: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' LICENSE: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' LICENSE: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' LICENSE: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LICENSE: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' LICENSE: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
' LICENSE: SOFTWARE.
function Rooibos__Init(args, preTestSetup = invalid,  testUtilsDecoratorMethodName = invalid, testSceneName = "TestsScene") as void
  if args.RunTests = invalid or args.RunTests <> "true" or createObject("roAPPInfo").IsDev() <> true then
    return
  end if
  args.testUtilsDecoratorMethodName = testUtilsDecoratorMethodName
  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)
  ? "Starting test using test scene with name TestsScene" ; testSceneName
  scene = screen.CreateScene(testSceneName)
  scene.id = "ROOT"
  screen.show()
  m.global = screen.getGlobalNode()
  if (preTestSetup <> invalid)
    preTestSetup(screen)
  end if
  testId = args.TestId
  if (testId = invalid)
    testId = "UNDEFINED_TEST_ID"
  end if
  ? "#########################################################################"
  ? "#TEST START : ###" ; testId ; "###"
  args.testScene = scene
  args.global = m.global
  runner = RBS_TR_TestRunner(args)
  runner.Run()
  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed()
        return
      end if
    end if
  end while
end function
function BaseTestSuite() as Object
  this = {}
  this.Name               = "BaseTestSuite"
  this.invalidValue = "#ROIBOS#INVALID_VALUE" ' special value used in mock arguments
  this.ignoreValue = "#ROIBOS#IGNORE_VALUE" ' special value used in mock arguments
  this.allowNonExistingMethodsOnMocks = true
  this.isAutoAssertingMocks = true
  this.TestCases = []
  this.AddTest            = RBS_BTS_AddTest
  this.CreateTest           = RBS_BTS_CreateTest
  this.GetLegacyCompatibleReturnValue = RBS_BTS_GetLegacyCompatibleReturnValue
  this.Fail               = RBS_BTS_Fail
  this.AssertFalse          = RBS_BTS_AssertFalse
  this.AssertTrue           = RBS_BTS_AssertTrue
  this.AssertEqual          = RBS_BTS_AssertEqual
  this.AssertLike           = RBS_BTS_AssertLike
  this.AssertNotEqual         = RBS_BTS_AssertNotEqual
  this.AssertInvalid          = RBS_BTS_AssertInvalid
  this.AssertNotInvalid         = RBS_BTS_AssertNotInvalid
  this.AssertAAHasKey         = RBS_BTS_AssertAAHasKey
  this.AssertAANotHasKey        = RBS_BTS_AssertAANotHasKey
  this.AssertAAHasKeys        = RBS_BTS_AssertAAHasKeys
  this.AssertAANotHasKeys       = RBS_BTS_AssertAANotHasKeys
  this.AssertArrayContains      = RBS_BTS_AssertArrayContains
  this.AssertArrayNotContains     = RBS_BTS_AssertArrayNotContains
  this.AssertArrayContainsSubset    = RBS_BTS_AssertArrayContainsSubset
  this.AssertArrayContainsAAs     = RBS_BTS_AssertArrayContainsAAs
  this.AssertArrayNotContainsSubset   = RBS_BTS_AssertArrayNotContainsSubset
  this.AssertArrayCount         = RBS_BTS_AssertArrayCount
  this.AssertArrayNotCount      = RBS_BTS_AssertArrayNotCount
  this.AssertEmpty          = RBS_BTS_AssertEmpty
  this.AssertNotEmpty         = RBS_BTS_AssertNotEmpty
  this.AssertArrayContainsOnlyValuesOfType    = RBS_BTS_AssertArrayContainsOnlyValuesOfType
  this.AssertType           = RBS_BTS_AssertType
  this.AssertSubType        = RBS_BTS_AssertSubType
  this.AssertNodeCount         = RBS_BTS_AssertNodeCount
  this.AssertNodeNotCount      = RBS_BTS_AssertNodeNotCount
  this.AssertNodeEmpty        = RBS_BTS_AssertNodeEmpty
  this.AssertNodeNotEmpty      = RBS_BTS_AssertNodenotEmpty
  this.AssertNodeContains      = RBS_BTS_AssertNodeContains
  this.AssertNodeNotContains     = RBS_BTS_AssertNodeNotContains
  this.AssertNodeContainsFields    = RBS_BTS_AssertNodeContainsFields
  this.AssertNodeNotContainsFields   = RBS_BTS_AssertNodeNotContainsFields
  this.AssertAAContainsSubset   = RBS_BTS_AssertAAContainsSubset
  this.EqValues             = RBS_BTS_EqValues
  this.EqAssocArrays          = RBS_BTS_EqAssocArray
  this.EqArray             = RBS_BTS_EqArray
  this.Stub       = RBS_BTS_Stub
  this.Mock       = RBS_BTS_Mock
  this.AssertMocks    = RBS_BTS_AssertMocks
  this.CreateFake     = RBS_BTS_CreateFake
  this.MockFail     = RBS_BTS_MockFail
  this.CleanMocks     = RBS_BTS_CleanMocks
  this.CleanStubs     = RBS_BTS_CleanStubs
  this.ExpectOnce         = RBS_BTS_ExpectOnce
  this.ExpectNone         = RBS_BTS_ExpectNone
  this.Expect             = RBS_BTS_Expect
  this.ExpectOnceOrNone   = RBS_BTS_ExpectOnceOrNone
  this.MockCallback0     = RBS_BTS_MockCallback0
  this.MockCallback1     = RBS_BTS_MockCallback1
  this.MockCallback2     = RBS_BTS_MockCallback2
  this.MockCallback3     = RBS_BTS_MockCallback3
  this.MockCallback4     = RBS_BTS_MockCallback4
  this.MockCallback5     = RBS_BTS_MockCallback5
  this.StubCallback0     = RBS_BTS_StubCallback0
  this.StubCallback1     = RBS_BTS_StubCallback1
  this.StubCallback2     = RBS_BTS_StubCallback2
  this.StubCallback3     = RBS_BTS_StubCallback3
  this.StubCallback4     = RBS_BTS_StubCallback4
  this.StubCallback5     = RBS_BTS_StubCallback5
  this.pathAsArray_ = RBS_BTS_rodash_pathsAsArray_
  this.g = RBS_BTS_rodash_get_
  return this
End Function
Sub RBS_BTS_AddTest(name, func,funcName, setup = invalid, teardown = invalid)
  m.testCases.Push(m.createTest(name, func, setup, teardown))
End Sub
Function RBS_BTS_CreateTest(name, func, funcName, setup = invalid, teardown = invalid ) as Object
  if (func = invalid) 
    ? " ASKED TO CREATE TEST WITH INVALID FUNCITON POINTER FOR FUNCTION " ; funcName
  end if
  return {
    Name: name 
    Func: func
    FuncName: funcName
    SetUp: setup
    TearDown: teardown
  }
End Function
Function RBS_BTS_Fail(msg = "Error" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  m.currentResult.AddResult(msg)
  return m.GetLegacyCompatibleReturnValue(false)
End Function
Function RBS_BTS_GetLegacyCompatibleReturnValue(value) as Object
  if (value = true)
  if (m.isLegacy = true)
    return ""
  else
    return true
  end if
  else  
  if (m.isLegacy = true)
    return "ERROR"
  else
    return false
  end if
  end if 
End Function
Function RBS_BTS_AssertFalse(expr as dynamic, msg = "Expression evaluates to true" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if not RBS_CMN_IsBoolean(expr) or expr 
    m.currentResult.AddResult(msg)
    return m.fail(msg)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertTrue(expr as dynamic, msg = "Expression evaluates to false" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if not RBS_CMN_IsBoolean(expr) or not expr then
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  End if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertEqual(first as dynamic, second as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if not m.eqValues(first, second)
    if msg = ""
      first_as_string = RBS_CMN_AsString(first)
      second_as_string = RBS_CMN_AsString(second)
      msg = first_as_string + " != " + second_as_string 
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertLike(first as dynamic, second as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if first <> second
    if msg = ""
      first_as_string = RBS_CMN_AsString(first)
      second_as_string = RBS_CMN_AsString(second)
      msg = first_as_string + " != " + second_as_string 
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNotEqual(first as dynamic, second as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if m.eqValues(first, second)
    if msg = ""
      first_as_string = RBS_CMN_AsString(first)
      second_as_string = RBS_CMN_AsString(second)
      msg = first_as_string + " == " + second_as_string 
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertInvalid(value as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if value <> Invalid
    if msg = ""
      expr_as_string = RBS_CMN_AsString(value)
      msg = expr_as_string + " <> Invalid"
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNotInvalid(value as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if value = Invalid
    if msg = ""
      expr_as_string = RBS_CMN_AsString(value)
      msg = expr_as_string + " = Invalid"
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertAAHasKey(array as dynamic, key as string, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array)
    if not array.DoesExist(key)
      if msg = ""
        msg = "Array doesn't have the '" + key + "' key."
      end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Associative Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertAANotHasKey(array as dynamic, key as string, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array)
    if array.DoesExist(key)
      if msg = ""
        msg = "Array has the '" + key + "' key."
      end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Associative Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertAAHasKeys(array as dynamic, keys as object, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsArray(keys)
    for each key in keys
      if not array.DoesExist(key)
        if msg = ""
          msg = "Array doesn't have the '" + key + "' key."
        end if
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
      end if
    end for
  else
    msg = "Input value is not an Associative Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertAANotHasKeys(array as dynamic, keys as object, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsArray(keys)
    for each key in keys
      if array.DoesExist(key)
        if msg = ""
          msg = "Array has the '" + key + "' key."
        end if
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
      end if
    end for
  else
    msg = "Input value is not an Associative Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
    if not RBS_CMN_ArrayContains(array, value, key)
      msg = "Array doesn't have the '" + RBS_CMN_AsString(value) + "' value."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayContainsAAs(array as dynamic, values as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if not RBS_CMN_IsArray(values)
    msg = "values to search for are not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  if RBS_CMN_IsArray(array)
    for each value in values
    isMatched = false
    if not RBS_CMN_IsAssociativeArray(value)
      msg = "Value to search for was not associativeArray "+  RBS_CMN_AsString(value)
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
    for each item in array
      if (RBS_CMN_IsAssociativeArray(item))
      isValueMatched = true
      for each key in value
        fieldValue = value[key]
        itemValue = item[key]
        if (not m.EqValues(fieldValue, itemValue))
        isValueMatched = false
        exit for
        end if
      end for
      if (isValueMatched)
        isMatched = true
        exit for
      end if
      end if
    end for ' items in array
    if not isMatched
      msg = "array missing value: "+  RBS_CMN_AsString(value)
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
    end for 'values to match
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayNotContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
    if RBS_CMN_ArrayContains(array, value, key)
      msg = "Array has the '" + RBS_CMN_AsString(value) + "' value."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) or (RBS_CMN_IsArray(array) and RBS_CMN_IsArray(subset))
    isAA = RBS_CMN_IsAssociativeArray(subset)
    for each item in subset
      key = invalid
      value = item
      if isAA
        key = item
        value = subset[key]
      end if
      if not RBS_CMN_ArrayContains(array, value, key)
        msg = "Array doesn't have the '" + RBS_CMN_AsString(value) + "' value."
        m.currentResult.AddResult(msg)
        return m.GetLegacyCompatibleReturnValue(false)
      end if
    end for
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayNotContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) or (RBS_CMN_IsArray(array) and RBS_CMN_IsArray(subset))
    isAA = RBS_CMN_IsAssociativeArray(subset)
    for each item in subset
      key = invalid
      value = item
      if isAA
        key = item
        value = item[key]
      end if
      if RBS_CMN_ArrayContains(array, value, key)
        msg = "Array has the '" + RBS_CMN_AsString(value) + "' value."
        m.currentResult.AddResult(msg)
        return m.GetLegacyCompatibleReturnValue(false)
      end if
    end for
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayCount(array as dynamic, count as integer, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
    if array.Count() <> count
      msg = "Array items count " + RBS_CMN_AsString(array.Count()) + " <> " + RBS_CMN_AsString(count) + "."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayNotCount(array as dynamic, count as integer, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
    if array.Count() = count
      msg = "Array items count = " + RBS_CMN_AsString(count) + "."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertEmpty(item as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(item) or RBS_CMN_IsArray(item)
    if item.Count() > 0
      msg = "Array is not empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else if (RBS_CMN_IsString(item))
    if (RBS_CMN_AsString(item) <> "")
      msg = "Input value is not empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else 
    msg = "AssertEmpty: Input value was not an array or a string"
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNotEmpty(item as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if RBS_CMN_IsAssociativeArray(item) or RBS_CMN_IsArray(item)
    if item.Count() = 0
      msg = "Array is empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else if RBS_CMN_IsString(item)
    if (item = "")
      msg = "Input value is empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not a string or array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertArrayContainsOnlyValuesOfType(array as dynamic, typeStr as string, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if typeStr <> "String" and typeStr <> "Integer" and typeStr <> "Boolean" and typeStr <> "Array" and typeStr <> "AssociativeArray"
    msg = "Type must be Boolean, String, Array, Integer, or AssociativeArray"
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false) 
  end if
  if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
    methodName = "RBS_CMN_Is" + typeStr
    typeCheckFunction = RBS_CMN_GetIsTypeFunction(methodName)
    if (typeCheckFunction <> invalid)
      for each item in array
        if not typeCheckFunction(item)
          msg = RBS_CMN_AsString(item) + "is not a '" + typeStr + "' type."
          m.currentResult.AddResult(msg)
          return m.GetLegacyCompatibleReturnValue(false)
        end if  
      end for
    else
      msg = "could not find comparator for type '" + typeStr + "' type."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)  
    end if
  else
    msg = "Input value is not an Array."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
function RBS_CMN_GetIsTypeFunction(name)
  if name = "RBS_CMN_IsFunction"
    return RBS_CMN_IsFunction
  else if name = "RBS_CMN_IsXmlElement"
    return RBS_CMN_IsXmlElement
  else if name = "RBS_CMN_IsInteger"
    return RBS_CMN_IsInteger
  else if name = "RBS_CMN_IsBoolean"
    return RBS_CMN_IsBoolean
  else if name = "RBS_CMN_IsFloat"
    return RBS_CMN_IsFloat
  else if name = "RBS_CMN_IsDouble"
    return RBS_CMN_IsDouble
  else if name = "RBS_CMN_IsLongInteger"
    return RBS_CMN_IsLongInteger
  else if name = "RBS_CMN_IsNumber"
    return RBS_CMN_IsNumber
  else if name = "RBS_CMN_IsList"
    return RBS_CMN_IsList
  else if name = "RBS_CMN_IsArray"
    return RBS_CMN_IsArray
  else if name = "RBS_CMN_IsAssociativeArray"
    return RBS_CMN_IsAssociativeArray
  else if name = "RBS_CMN_IsSGNode"
    return RBS_CMN_IsSGNode
  else if name = "RBS_CMN_IsString"
    return RBS_CMN_IsString
  else if name = "RBS_CMN_IsDateTime"
    return RBS_CMN_IsDateTime
  else if name = "RBS_CMN_IsUndefined"
    return RBS_CMN_IsUndefined
  else
    return invalid
  end if
end function
function RBS_BTS_AssertType(value as dynamic, typeStr as string, msg ="" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(value) <> typeStr
    if msg = ""
      expr_as_string = RBS_CMN_AsString(value)
      msg = expr_as_string + " was not expected type " + typeStr
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
end function
function RBS_BTS_AssertSubType(value as dynamic, typeStr as string, msg ="" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(value) <> "roSGNode"
    if msg = ""
      expr_as_string = RBS_CMN_AsString(value)
      msg = expr_as_string + " was not a node, so could not match subtype " + typeStr
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  else if (value.subType() <> typeStr)
    if msg = ""
      expr_as_string = RBS_CMN_AsString(value)
      msg = expr_as_string + "( type : " + value.subType() +") was not of subType " + typeStr
    end if
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
end function
Function RBS_BTS_EqValues(Value1 as dynamic, Value2 as dynamic) as dynamic
  val1Type = type(Value1)
  val2Type = type(Value2)
  if val1Type = "<uninitialized>" or val2Type = "<uninitialized>" or val1Type = "" or val2Type = ""
    ? "ERROR!!!! - undefined value passed"
    return false
  end if 
  if val1Type = "roString" or val1Type = "String"
    Value1 = RBS_CMN_AsString(Value1)
  else
    Value1 = box(Value1)
  end if
  if val2Type = "roString" or val2Type = "String"
    Value2 = RBS_CMN_AsString(Value2)
  else
    Value2 = box(Value2)
  end if
  val1Type = type(Value1)
  val2Type = type(Value2)
  if val1Type = "roFloat" and val2Type = "roInt"
    Value2 = box(Cdbl(Value2))
  else if val2Type = "roFloat" and val1Type = "roInt"
    Value1 = box(Cdbl(Value1))
  end if
  if val1Type <> val2Type
    return false
  else
    valtype = val1Type
    if valtype = "roList"
      return m.eqArray(Value1, Value2)
    else if valtype = "roAssociativeArray"
      return m.eqAssocArrays(Value1, Value2)
    else if valtype = "roArray"
      return m.eqArray(Value1, Value2)
    else if (valtype = "roSGNode")
      if (val2Type <> "roSGNode")
        return false
      else
        return Value1.isSameNode(Value2)
      end if
    else
      return Value1 = Value2
    end if  
  end if
End Function 
Function RBS_BTS_EqAssocArray(Value1 as Object, Value2 as Object) as dynamic
  l1 = Value1.Count()
  l2 = Value2.Count()
  if not l1 = l2
    return false
  else
    for each k in Value1
      if not Value2.DoesExist(k)
        return false
      else
        v1 = Value1[k]
        v2 = Value2[k]
        if not m.eqValues(v1, v2)
          return false
        end if
      end if
    end for
    return true
  end if
End Function 
Function RBS_BTS_EqArray(Value1 as Object, Value2 as Object) as dynamic
  if not (RBS_CMN_IsArray(Value1)) or not RBS_CMN_IsArray(Value2) then return false
  l1 = Value1.Count()
  l2 = Value2.Count()
  if not l1 = l2
    return false
  else
    for i = 0 to l1 - 1
      v1 = Value1[i]
      v2 = Value2[i]
      if not m.eqValues(v1, v2) then
        return false
      end if
    end for
    return true
  end if
End Function
Function RBS_BTS_AssertNodeCount(node as dynamic, count as integer, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(node) = "roSGNode" 
    if node.getChildCount() <> count
      msg = "node items count <> " + RBS_CMN_AsString(count) + ". Received " + RBS_CMN_AsString(node.getChildCount())
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeNotCount(node as dynamic, count as integer, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(node) = "roSGNode" 
    if node.getChildCount() = count
      msg = "node items count = " + RBS_CMN_AsString(count) + "."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeEmpty(node as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(node) = "roSGNode" 
    if node.getChildCount() > 0
      msg = "node is not empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeNotEmpty(node as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if type(node) = "roSGNode" 
    if node.Count() = 0
      msg = "Array is empty."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeContains(node as dynamic, value as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if  type(node) = "roSGNode" 
    if not RBS_CMN_NodeContains(node, value)
      msg = "Node doesn't have the '" + RBS_CMN_AsString(value) + "' value."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeContainsOnly(node as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if  type(node) = "roSGNode" 
    if not RBS_CMN_NodeContains(node, value)
      msg = "Node doesn't have the '" + RBS_CMN_AsString(value) + "' value."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    else if node.getChildCount() <> 1
      msg = "Node Contains speicified value; but other values as well"
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeNotContains(node as dynamic, value as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if  type(node) = "roSGNode" 
    if RBS_CMN_NodeContains(node, value)
      msg = "Node has the '" + RBS_CMN_AsString(value) + "' value."
      m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
    end if
  else
    msg = "Input value is not an Node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeContainsFields(node as dynamic, subset as dynamic, ignoredFields=invalid, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if ( type(node) = "roSGNode" and RBS_CMN_IsAssociativeArray(subset)) or ( type(node) = "roSGNode"  and RBS_CMN_IsArray(subset))
    isAA = RBS_CMN_IsAssociativeArray(subset)
    isIgnoredFields = RBS_CMN_IsArray(ignoredFields)
    for each key in subset
      if (key <> "")
        if (not isIgnoredFields or not RBS_CMN_ArrayContains(ignoredFields, key))
          subsetValue = subset[key]
          nodeValue = node[key]
          if not m.eqValues(nodeValue, subsetValue)
            msg = key + ": Expected '" + RBS_CMN_AsString(subsetValue) + "', got '" + RBS_CMN_AsString(nodeValue) + "'"
            m.currentResult.AddResult(msg)
            return m.GetLegacyCompatibleReturnValue(false)
          end if
        end if
      else
        ? "Found empty key!"  
      end if
    end for
  else
    msg = "Input value is not an Node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertNodeNotContainsFields(node as dynamic, subset as dynamic, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if ( type(node) = "roSGNode"  and RBS_CMN_IsAssociativeArray(subset)) or ( type(node) = "roSGNode" and RBS_CMN_IsArray(subset))
    isAA = RBS_CMN_IsAssociativeArray(subset)
    for each item in subset
      key = invalid
      value = item
      if isAA
        key = item
        value = item[key]
      end if
      if RBS_CMN_NodeContains(node, value, key)
        msg = "Node has the '" + RBS_CMN_AsString(value) + "' value."
        m.currentResult.AddResult(msg)
      return m.GetLegacyCompatibleReturnValue(false)
      end if
    end for
  else
    msg = "Input value is not an Node."
    m.currentResult.AddResult(msg)
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
Function RBS_BTS_AssertAAContainsSubset(array as dynamic, subset as dynamic, ignoredFields = invalid, msg = "" as string) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) 
    isAA = RBS_CMN_IsAssociativeArray(subset)
    isIgnoredFields = RBS_CMN_IsArray(ignoredFields)
    for each key in subset
      if (key <> "")
        if (not isIgnoredFields or not RBS_CMN_ArrayContains(ignoredFields, key))
          subsetValue = subset[key]
          arrayValue = array[key]
          if not m.eqValues(arrayValue, subsetValue)
            msg = key + ": Expected '" + RBS_CMN_AsString(subsetValue) + "', got '" + RBS_CMN_AsString(arrayValue) + "'"
            m.currentResult.AddResult(msg)
            return m.GetLegacyCompatibleReturnValue(false)
          end if
        end if
      else
        ? "Found empty key!"  
      end if
    end for
  else
    msg = "Input values are not an Associative Array."
    return m.GetLegacyCompatibleReturnValue(false)
  end if
  m.currentResult.AddResult("")
  return m.GetLegacyCompatibleReturnValue(true)
End Function
function RBS_BTS_Stub(target, methodName, returnValue = invalid, allowNonExistingMethods = false) as object
  if (type(target) <> "roAssociativeArray")
    m.Fail("could not create Stub provided target was null")
    return {}
  end if
  if (m.stubs =invalid)
    m.__stubId = -1
    m.stubs = {}
  end if
  m.__stubId++
  if (m.__stubId > 5)
     ? "ERROR ONLY 6 STUBS PER TEST ARE SUPPORTED!!"
     return invalid
  end if
  id = stri(m.__stubId).trim()
  fake = m.CreateFake(id, target, methodName, 1, invalid, returnValue)
  m.stubs[id] = fake
  allowNonExisting = m.allowNonExistingMethodsOnMocks = true or allowNonExistingMethods
  if (type(target[methodName]) = "Function" or type(target[methodName]) = "roFunction" or allowNonExisting)
    target[methodName] = m["StubCallback" + id]
    target.__stubs = m.stubs
    if (allowNonExisting)
      ? "WARNING - stubbing call " ; methodName; " which did not exist on target object"
    end if
  else
    ? "ERROR - could not create Stub : method not found  "; target ; "." ; methodName 
  end if
  return fake
end function
function RBS_BTS_ExpectOnce(target, methodName, expectedArgs = invalid, returnValue = invalid, allowNonExistingMethods = false) as object
  return m.Mock(target, methodName, 1, expectedArgs, returnValue, allowNonExistingMethods)
end function 
function RBS_BTS_ExpectOnceOrNone(target, methodName, isExpected, expectedArgs = invalid, returnValue = invalid, allowNonExistingMethods = false) as object
  if isExpected
    return m.ExpectOnce(target, methodName, expectedArgs, returnValue, allowNonExistingMethods)
  else
    return m.ExpectNone(target, methodName, allowNonExistingMethods)
  end if
end function 
function RBS_BTS_ExpectNone(target, methodName, allowNonExistingMethods = false) as object
  return m.Mock(target, methodName, 0, invalid, invalid, allowNonExistingMethods)
end function 
function RBS_BTS_Expect(target, methodName, expectedInvocations = 1, expectedArgs = invalid, returnValue = invalid, allowNonExistingMethods = false) as object
  return m.Mock(target, methodName, expectedInvocations, expectedArgs, returnValue, allowNonExistingMethods)
end function 
function RBS_BTS_Mock(target, methodName, expectedInvocations = 1, expectedArgs = invalid, returnValue = invalid, allowNonExistingMethods = false) as object
  if (type(target) <> "roAssociativeArray")
    m.Fail("could not create Stub provided target was null")
    return {}
  end if
  if (m.mocks = invalid)
    m.__mockId = -1
    m.mocks = {}
  end if
  m.__mockId++
  if (m.__mockId > 5)
     ? "ERROR ONLY 6 MOCKS PER TEST ARE SUPPORTED!! you're on # " ; m.__mockId
     ? " Method was " ; methodName
     return invalid
  end if
  id = stri(m.__mockId).trim()
  fake = m.CreateFake(id, target, methodName, expectedInvocations, expectedArgs, returnValue)
  m.mocks[id] = fake 'this will bind it to m
  allowNonExisting = m.allowNonExistingMethodsOnMocks = true or allowNonExistingMethods
  if (type(target[methodName]) = "Function" or type(target[methodName]) = "roFunction" or allowNonExisting)
    target[methodName] =  m["MockCallback" + id]
    target.__mocks = m.mocks
    if (allowNonExisting)
      ? "WARNING - mocking call " ; methodName; " which did not exist on target object"
    end if
  else
    ? "ERROR - could not create Mock : method not found  "; target ; "." ; methodName 
  end if
  return fake
end function
function RBS_BTS_CreateFake(id, target, methodName, expectedInvocations = 1, expectedArgs =invalid, returnValue=invalid ) as object
  expectedArgsValues = []
  hasArgs = expectedArgs <> invalid
  if (hasArgs)
    defaultValue = m.invalidValue
  else
    defaultValue = m.ignoreValue
  end if 
  for i = 0 to 9
    if (hasArgs and expectedArgs.count() > i)
      value = expectedArgs[i]
      if not RBS_CMN_IsUndefined(value)
        expectedArgsValues.push(expectedArgs[i])
      else
        expectedArgsValues.push("#ERR-UNDEFINED!")
      end if    
    else
      expectedArgsValues.push(defaultValue)
    end if
  end for
  fake = {
    id : id,
    target: target,
    methodName: methodName,
    returnValue: returnValue, 
    isCalled: false,
    invocations: 0,
    invokedArgs: [invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid],
    expectedArgs: expectedArgsValues,
    expectedInvocations: expectedInvocations,
    callback: function (arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
      ? "FAKE CALLBACK CALLED FOR " ; m.methodName 
      if (m.allInvokedArgs = invalid)
        m.allInvokedArgs = []
      end if
      m.invokedArgs = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 ]
      m.allInvokedArgs.push ([arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 ]) 
      m.isCalled = true
      m.invocations++
      if (type(m.returnValue) = "roAssociativeArray" and m.returnValue.doesExist("multiResult"))
        returnValues = m.returnValue["multiResult"]
        returnIndex = m.invocations -1
        if (type(returnValues) = "roArray" and returnValues.count() > 0)
        if returnValues.count() <= m.invocations
          returnIndex = returnValues.count() -1
          print "Multi return values all used up - repeating last value"
        end if
          return returnValues[returnIndex] 
        else
          ? "Multi return value was specified; but no array of results were found"
          return invalid
        end if
      else
        return m.returnValue
      end if
    end function
    }
  return fake
end function
function RBS_BTS_AssertMocks() as void
  if (m.__mockId = invalid ) return
  lastId = int(m.__mockId)
  for each id in m.mocks
    mock = m.mocks[id]
    methodName = mock.methodName
    if (mock.expectedInvocations <> mock.invocations)
      m.MockFail(methodName, "Wrong number of calls. (" + stri(mock.invocations).trim() + " / " + stri(mock.expectedInvocations).trim() + ")")
      return
    else if (mock.expectedInvocations > 0 and RBS_CMN_IsArray(mock.expectedArgs))
      for i = 0 to mock.expectedargs.count() -1
        value = mock.invokedArgs[i]
        expected = mock.expectedargs[i]
        didNotExpectArg = RBS_CMN_IsString(expected) and expected = m.invalidValue 
        if (didNotExpectArg)
          expected = invalid
        end if
        if (not (RBS_CMN_IsString(expected) and expected = m.ignoreValue) and not m.eqValues(value, expected))
          if (expected = invalid)
            expected = "[INVALID]"
          end if
          m.MockFail(methodName, "Expected arg #" + stri(i).trim() + "  to be '" + RBS_CMN_AsString(expected) + "' got '" + RBS_CMN_AsString(value) + "')")
          return
        end if
      end for
     end if
  end for
  m.CleanMocks()
end function
function RBS_BTS_CleanMocks() as void
  if m.mocks = invalid return
  for each id in m.mocks
    mock = m.mocks[id]
    mock.target.__mocks = invalid
  end for
  m.mocks = invalid
end function
function RBS_BTS_CleanStubs() as void
  if m.stubs = invalid return
  for each id in m.stubs
    stub = m.stubs[id]
    stub.target.__stubs = invalid
  end for
  m.stubs = invalid
end function
Function RBS_BTS_MockFail(methodName, message) as dynamic
  if (m.currentResult.isFail) then return m.GetLegacyCompatibleReturnValue(false) ' skip test we already failed
  m.currentResult.AddResult("mock failure on '" + methodName + "' : "  + message)
  return m.GetLegacyCompatibleReturnValue(false)
End Function
function RBS_BTS_StubCallback0(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["0"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_StubCallback1(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["1"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_StubCallback2(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["2"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_StubCallback3(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["3"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_StubCallback4(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["4"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_StubCallback5(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__Stubs["5"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback0(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["0"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback1(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["1"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback2(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["2"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback3(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["3"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback4(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["4"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
function RBS_BTS_MockCallback5(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
  fake = m.__mocks["5"]
  return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function
Function RBS_BTS_rodash_pathsAsArray_(path)
  pathRE = CreateObject("roRegex", "\[([0-9]+)\]", "i")
  segments = []
  if type(path) = "String" or type(path) = "roString"
    dottedPath = pathRE.replaceAll(path, ".\1")
    stringSegments = dottedPath.tokenize(".")
    for each s in stringSegments
      if (Asc(s) >= 48) and (Asc(s) <= 57)
        segments.push(s.toInt())
      else
        segments.push(s)
      end if
    end for
  else if type(path) = "roList" or type(path) = "roArray"
    stringPath = ""
    for each s in path
      stringPath = stringPath + "." + Box(s).toStr()
    end for
    segments = m.pathAsArray_(stringPath)
  else
    segments = invalid
  end if
  return segments
End Function
Function RBS_BTS_rodash_get_(aa, path, default=invalid)
  if type(aa) <> "roAssociativeArray" and type(aa) <> "roArray" and type(aa) <> "roSGNode" then return default
  segments = m.pathAsArray_(path)
  if (Type(path) = "roInt" or Type(path) = "roInteger" or Type(path) = "Integer")
    path = stri(path).trim()
  end if
  if segments = invalid then return default
  result = invalid
  while segments.count() > 0
    key = segments.shift()
    if (type(key) = "roInteger") 'it's a valid index
      if (aa <> invalid and GetInterface(aa, "ifArray") <> invalid)
        value = aa[key]
      else if (aa <> invalid and GetInterface(aa, "ifSGNodeChildren") <> invalid)
        value = aa.getChild(key)
      else if (aa <> invalid and GetInterface(aa, "ifAssociativeArray") <> invalid)
        key = tostr(key)
        if not aa.doesExist(key)
          exit while
        end if
        value = aa.lookup(key)
      else 
        value = invalid
      end if
    else
      if not aa.doesExist(key)
        exit while
      end if
      value = aa.lookup(key)
    end if
    if segments.count() = 0
      result = value
      exit while
    end if
    if type(value) <> "roAssociativeArray" and type(value) <> "roArray" and type(value) <> "roSGNode"
      exit while
    end if
    aa = value
  end while
  if result = invalid then return default
    return result
End Function
function RBS_CMN_IsXmlElement(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifXMLElement") <> invalid
end function
function RBS_CMN_IsFunction(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifFunction") <> invalid
end function
function RBS_CMN_GetFunction(filename, functionName) as Object
  if (not RBS_CMN_IsNotEmptyString(functionName)) then return invalid
  if (not RBS_CMN_IsNotEmptyString(filename)) then return invalid
  mapFunction = RBSFM_getFuncitonsForFile(filename)
  if mapFunction <> invalid
    map = mapFunction()
    if (type(map) ="roAssociativeArray")
      functionPointer = map[functionName]
      return functionPointer
    else
      return invalid
    end if
  end if
  return invalid
end function
function RBS_CMN_IsBoolean(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifBoolean") <> invalid
end function
function RBS_CMN_IsInteger(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifInt") <> invalid and (Type(value) = "roInt" or Type(value) = "roInteger" or Type(value) = "Integer")
end function
function RBS_CMN_IsFloat(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifFloat") <> invalid
end function
function RBS_CMN_IsDouble(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifDouble") <> invalid
end function
function RBS_CMN_IsLongInteger(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifLongInt") <> invalid
end function
function RBS_CMN_IsNumber(value as Dynamic) as Boolean
  return RBS_CMN_IsLongInteger(value) or RBS_CMN_IsDouble(value) or RBS_CMN_IsInteger(value) or RBS_CMN_IsFloat(value)
end function
function RBS_CMN_IsList(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifList") <> invalid
end function
function RBS_CMN_IsArray(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifArray") <> invalid
end function
function RBS_CMN_IsAssociativeArray(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifAssociativeArray") <> invalid
end function
function RBS_CMN_IsSGNode(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifSGNodeChildren") <> invalid
end function
function RBS_CMN_IsString(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and GetInterface(value, "ifString") <> invalid
end function
function RBS_CMN_IsNotEmptyString(value as Dynamic) as Boolean
  return RBS_CMN_IsString(value) and len(value) > 0
end function
function RBS_CMN_IsDateTime(value as Dynamic) as Boolean
  return RBS_CMN_IsValid(value) and (GetInterface(value, "ifDateTime") <> invalid or Type(value) = "roDateTime")
end function
function RBS_CMN_IsValid(value as Dynamic) as Boolean
  return not RBS_CMN_IsUndefined(value) and value <> invalid
end function
function RBS_CMN_IsUndefined(value as Dynamic) as Boolean
  return type(value) = "" or Type(value) = "<uninitialized>"
end function
function RBS_CMN_ValidStr(obj as Object) as String
  if obj <> invalid and GetInterface(obj, "ifString") <> invalid
    return obj
  else
    return ""
  end if
end function 
function RBS_CMN_AsString(input as Dynamic) as String
  if RBS_CMN_IsValid(input) = false
    return ""
  else if RBS_CMN_IsString(input)
    return input
  else if RBS_CMN_IsInteger(input) or RBS_CMN_IsLongInteger(input) or RBS_CMN_IsBoolean(input)
    return input.ToStr()
  else if RBS_CMN_IsFloat(input) or RBS_CMN_IsDouble(input)
    return Str(input).Trim()
  else if type(input) = "roSGNode"
    return "Node(" + input.subType() +")"
  else if type(input) = "roAssociativeArray"
    isFirst = true
    text = "{"
    if (not isFirst)
      text += ","
      isFirst = false
    end if
    for each key in input
      text += key + ":" + RBS_CMN_AsString(input[key])
    end for
    text += "}"
    return text
  else
    return ""
  end If
end function
function RBS_CMN_AsInteger(input as Dynamic) as Integer
  if RBS_CMN_IsValid(input) = false
    return 0
  else if RBS_CMN_IsString(input)
    return input.ToInt()
  else if RBS_CMN_IsInteger(input)
    return input
  else if RBS_CMN_IsFloat(input) or RBS_CMN_IsDouble(input) or RBS_CMN_IsLongInteger(input)
    return Int(input)
  else
    return 0
  end if
end function
function RBS_CMN_AsLongInteger(input as Dynamic) as LongInteger
  if RBS_CMN_IsValid(input) = false
    return 0
  else if RBS_CMN_IsString(input)
    return RBS_CMN_AsInteger(input)
  else if RBS_CMN_IsLongInteger(input) or RBS_CMN_IsFloat(input) or RBS_CMN_IsDouble(input) or RBS_CMN_IsInteger(input)
    return input
  else
    return 0
  end if
end function
function RBS_CMN_AsFloat(input as Dynamic) as Float
  if RBS_CMN_IsValid(input) = false
    return 0.0
  else if RBS_CMN_IsString(input)
    return input.ToFloat()
  else if RBS_CMN_IsInteger(input)
    return (input / 1)
  else if RBS_CMN_IsFloat(input) or RBS_CMN_IsDouble(input) or RBS_CMN_IsLongInteger(input)
    return input
  else
    return 0.0
  end if
end function
function RBS_CMN_AsDouble(input as Dynamic) as Double
  if RBS_CMN_IsValid(input) = false
    return 0.0
  else if RBS_CMN_IsString(input)
    return RBS_CMN_AsFloat(input)
  else if RBS_CMN_IsInteger(input) or RBS_CMN_IsLongInteger(input) or RBS_CMN_IsFloat(input) or RBS_CMN_IsDouble(input)
    return input
  else
    return 0.0
  end if
end function
function RBS_CMN_AsBoolean(input as Dynamic) as Boolean
  if RBS_CMN_IsValid(input) = false
    return false
  else if RBS_CMN_IsString(input)
    return LCase(input) = "true"
  else if RBS_CMN_IsInteger(input) or RBS_CMN_IsFloat(input)
    return input <> 0
  else if RBS_CMN_IsBoolean(input)
    return input
  else
    return false
  end if
end function
function RBS_CMN_AsArray(value as Object) as Object
  if RBS_CMN_IsValid(value)
    if not RBS_CMN_IsArray(value)
      return [value]
    else
      return value
    end if
  end if
  return []
end function
function RBS_CMN_IsNullOrEmpty(value as Dynamic) as Boolean
  if RBS_CMN_IsString(value)
    return Len(value) = 0
  else
    return not RBS_CMN_IsValid(value)
  end if
end function
function RBS_CMN_FindElementIndexInArray(array as Object, value as Object, compareAttribute = invalid as Dynamic, caseSensitive = false as Boolean) as Integer
  if RBS_CMN_IsArray(array)
    for i = 0 to RBS_CMN_AsArray(array).Count() - 1
      compareValue = array[i]
      if compareAttribute <> invalid and RBS_CMN_IsAssociativeArray(compareValue)
        compareValue = compareValue.LookupCI(compareAttribute)
      end If
      if RBS_CMN_IsString(compareValue) and RBS_CMN_IsString(value) and not caseSensitive
        if LCase(compareValue) = LCase(value)
          return i
        end If
      else if compareValue = value
        return i
      end if
      item = array[i]
    next
  end if
  return -1
end function
function RBS_CMN_ArrayContains(array as Object, value as Object, compareAttribute = invalid as Dynamic) as Boolean
  return (RBS_CMN_FindElementIndexInArray(array, value, compareAttribute) > -1)
end function
function RBS_CMN_FindElementIndexInNode(node as Object, value as Object) as Integer
  if type(node) = "roSGNode" 
    for i = 0 to node.getChildCount() - 1
      compareValue = node.getChild(i)
      if type(compareValue) = "roSGNode" and compareValue.isSameNode(value)
        return i
      end if
    next
  end if
  return -1
end function
function RBS_CMN_NodeContains(node as Object, value as Object) as Boolean
  return (RBS_CMN_FindElementIndexInNode(node, value) > -1)
end function
function UnitTestItGroup(name, isSolo, isIgnored, filename)
  this = {}
  this.testCases = createObject("roArray", 0, true)
  this.ignoredTestCases = CreateObject("roArray",0, true)
  this.soloTestCases = CreateObject("roArray",0, true)
  this.filename = filename
  this.testCaseLookup = {}
  this.setupFunction = invalid
  this.setupFunctionName = ""
  this.tearDownFunction = invalid
  this.tearDownFunctionName = ""
  this.tearDownFunctionName = ""
  this.beforeEachFunction = invalid
  this.beforeEachFunctionName = ""
  this.afterEachFunction = invalid
  this.afterEachFunctionName = ""
  this.isSolo = isSolo
  this.isIgnored = isIgnored
  this.hasSoloTests = false
  this.name = name
  this.AddTestCase = RBS_ItG_AddTestCase
  return this
end function
function RBS_ItG_AddTestCase(testCase)
  if (testCase.isSolo)
    m.hasSoloTestCases = true
    m.soloTestCases.push(testCase)
    m.hasSoloTests = true
  else if (testCase.isIgnored)
    m.ignoredTestCases.push(testCase)
  else
    m.testCases.push(testCase)
  end if
end function
function RBS_ItG_GetTestCases(group) as object
  if (group.hasSoloTests)
    return group.soloTestCases
  else
    return group.testCases
  end if
end function
function RBS_ItG_GetRunnableTestSuite(group) as object
  testCases = RBS_ItG_GetTestCases(group)
  runnableSuite = BaseTestSuite()
  runnableSuite.name = group.name
  runnableSuite.isLegacy = group.isLegacy = true
  for each testCase in testCases
    name = testCase.name
    if (testCase.isSolo)
      name += " [SOLO] "
    end if
    testFunction = RBS_CMN_GetFunction(group.filename, testCase.funcName)
    runnableSuite.addTest(name, testFunction, testCase.funcName)
    group.testCaseLookup[name] = testCase
  end for
  runnableSuite.SetUp = RBS_CMN_GetFunction(group.filename, group.setupFunctionName)
  runnableSuite.TearDown =  RBS_CMN_GetFunction(group.filename, group.teardownFunctionName)
  runnableSuite.BeforeEach =  RBS_CMN_GetFunction(group.filename, group.beforeEachFunctionName) 
  runnableSuite.AfterEach =  RBS_CMN_GetFunction(group.filename, group.afterEachFunctionName) 
  return runnableSuite
end function
Function ItemGenerator(scheme as object) as Object
  this = {}
  this.getItem    = RBS_IG_GetItem
  this.getAssocArray  = RBS_IG_GetAssocArray
  this.getArray     = RBS_IG_GetArray
  this.getSimpleType  = RBS_IG_GetSimpleType
  this.getInteger   = RBS_IG_GetInteger
  this.getFloat     = RBS_IG_GetFloat
  this.getString    = RBS_IG_GetString
  this.getBoolean   = RBS_IG_GetBoolean
  if not RBS_CMN_IsValid(scheme)
    return invalid
  end if
  return this.getItem(scheme)
End Function
Function RBS_IG_GetItem(scheme as object) as object
  item = invalid
  if RBS_CMN_IsAssociativeArray(scheme)
    item = m.getAssocArray(scheme)
  else if RBS_CMN_IsArray(scheme)
    item = m.getArray(scheme)
  else if RBS_CMN_IsString(scheme) 
    item = m.getSimpleType(lCase(scheme))
  end if  
  return item
End Function
Function RBS_IG_GetAssocArray(scheme as object) as object
  item = {}
  for each key in scheme
    if not item.DoesExist(key)
      item[key] = m.getItem(scheme[key])
    end if
  end for
  return item
End Function
Function RBS_IG_GetArray(scheme as object) as object
  item = []
  for each key in scheme
    item.Push(m.getItem(key))
  end for
  return item
End Function
Function RBS_IG_GetSimpleType(typeStr as string) as object
  item = invalid
  if typeStr = "integer" or typeStr = "int" or typeStr = "roint"
    item = m.getInteger()
  else if typeStr = "float" or typeStr = "rofloat"
    item = m.getFloat()
  else if typeStr = "string" or typeStr = "rostring"
    item = m.getString(10)
  else if typeStr = "boolean" or typeStr = "roboolean"
    item = m.getBoolean()
  end if
  return item
End Function
Function RBS_IG_GetBoolean() as boolean
  return RBS_CMN_AsBoolean(Rnd(2) \ Rnd(2))
End Function
Function RBS_IG_GetInteger(seed = 100 as integer) as integer
  return Rnd(seed)
End Function
Function RBS_IG_GetFloat() as float
  return Rnd(0)
End Function
Function RBS_IG_GetString(seed as integer) as string
  item = ""
  if seed > 0
    stringLength = Rnd(seed)
    for i = 0 to stringLength
      chType = Rnd(3)
      if chType = 1     'Chr(48-57) - numbers
        chNumber = 47 + Rnd(10)
      else if chType = 2  'Chr(65-90) - Uppercase Letters
        chNumber = 64 + Rnd(26)
      else        'Chr(97-122) - Lowercase Letters
        chNumber = 96 + Rnd(26)
      end if
      item = item + Chr(chNumber)
    end for
  end if
  return item
End Function
function UnitTestRuntimeConfig(testsDirectory, maxLinesWithoutSuiteDirective, supportLegacyTests = false)
  this = {}
  this.testsDirectory = testsDirectory
  this.CreateSuites = RBS_CreateSuites
  this.hasSoloSuites = false
  this.hasSoloGroups = false
  this.hasSoloTests = false
  this.suites = this.CreateSuites(this.testsDirectory, maxLinesWithoutSuiteDirective, supportLegacyTests)
  return this
end function
function RBS_CreateSuites(testsDirectory, maxLinesWithoutSuiteDirective, supportLegacyTests )
  result =  CreateObject("roArray", 0, true)
  testsFileRegex = CreateObject("roRegex", "^[0-9a-z\_]*\.brs$", "i")
  if testsDirectory <> ""
    fileSystem = CreateObject("roFileSystem")
    listing = fileSystem.GetDirectoryListing(testsDirectory)
    for each item in listing
      itemPath = testsDirectory + "/" + item
      itemStat = fileSystem.Stat(itemPath)
      if itemStat.type = "directory" then
        result.append(m.CreateSuites(itemPath, maxLinesWithoutSuiteDirective, supportLegacyTests ))
      else if testsFileRegex.IsMatch(item) then
        suite = UnitTestSuite(itemPath, maxLinesWithoutSuiteDirective, supportLegacyTests)
        if (suite.isValid)
          if (suite.isSolo)
            m.hasSoloSuites = true
          end if
          if (suite.hasSoloTests)
            m.hasSoloTests = true
          end if
          if (suite.hasSoloGroups)
            m.hasSoloGroups = true
          end if
          result.Push(suite)
        else 
        end if
      end if
    end for
  end if
  return result
end function
function RBS_STATS_CreateTotalStatistic() as Object
  statTotalItem = {
    Suites    : []
    Time    : 0
    Total     : 0
    Correct   : 0
    Fail    : 0
    Ignored   : 0
    Crash     : 0
    IgnoredTestNames: []
  }
  return statTotalItem
end function
function RBS_STATS_MergeTotalStatistic(stat1, stat2) as void
  for each suite in stat2.Suites
    stat1.Suites.push(suite)
  end for  
  stat1.Time += stat2.Time
  stat1.Total += stat2.Total
  stat1.Correct += stat2.Correct
  stat1.Fail += stat2.Fail
  stat1.Crash += stat2.Crash
  stat1.Ignored += stat2.Ignored
  stat1.IgnoredTestNames.append(stat2.IgnoredTestNames)
end function
function RBS_STATS_CreateSuiteStatistic(name as String) as Object
  statSuiteItem = {
    Name  : name
    Tests   : []
    Time  : 0
    Total   : 0
    Correct : 0
    Fail  : 0
    Crash   : 0
    Ignored   : 0
    IgnoredTestNames:[]
  }
  return statSuiteItem
end function
function RBS_STATS_CreateTestStatistic(name as String, result = "Success" as String, time = 0 as Integer, errorCode = 0 as Integer, errorMessage = "" as String) as Object
  statTestItem = {
    Name  : name
    Result  : result
    Time  : time
    Error   : {
      Code  : errorCode
      Message : errorMessage
    }
  }
  return statTestItem
end function
sub RBS_STATS_AppendTestStatistic(statSuiteObj as Object, statTestObj as Object)
  if RBS_CMN_IsAssociativeArray(statSuiteObj) and RBS_CMN_IsAssociativeArray(statTestObj)
    statSuiteObj.Tests.Push(statTestObj)
    if RBS_CMN_IsInteger(statTestObj.time)
      statSuiteObj.Time = statSuiteObj.Time + statTestObj.Time
    end if
    statSuiteObj.Total = statSuiteObj.Total + 1
    if lCase(statTestObj.Result) = "success"
      statSuiteObj.Correct = statSuiteObj.Correct + 1
    else if lCase(statTestObj.result) = "fail"
      statSuiteObj.Fail = statSuiteObj.Fail + 1
    else
      statSuiteObj.crash = statSuiteObj.crash + 1
    end if
  end if
end sub
sub RBS_STATS_AppendSuiteStatistic(statTotalObj as Object, statSuiteObj as Object)
  if RBS_CMN_IsAssociativeArray(statTotalObj) and RBS_CMN_IsAssociativeArray(statSuiteObj)
    statTotalObj.Suites.Push(statSuiteObj)
    statTotalObj.Time = statTotalObj.Time + statSuiteObj.Time
    if RBS_CMN_IsInteger(statSuiteObj.Total)
      statTotalObj.Total = statTotalObj.Total + statSuiteObj.Total
    end if
    if RBS_CMN_IsInteger(statSuiteObj.Correct)
      statTotalObj.Correct = statTotalObj.Correct + statSuiteObj.Correct
    end if
    if RBS_CMN_IsInteger(statSuiteObj.Fail)
      statTotalObj.Fail = statTotalObj.Fail + statSuiteObj.Fail
    end if
    if RBS_CMN_IsInteger(statSuiteObj.Crash)
      statTotalObj.Crash = statTotalObj.Crash + statSuiteObj.Crash
    end if
  end if
end sub
function UnitTestCase(name as string, func as dynamic, funcName as string, isSolo as boolean, isIgnored as boolean, lineNumber as integer, params = invalid, paramTestIndex =0, paramLineNumber = 0)
  this = {}
  this.isSolo = isSolo
  this.func = func
  this.funcName = funcName
  this.isIgnored = isIgnored
  this.name = name
  this.lineNumber = lineNumber
  this.paramLineNumber = paramLineNumber
  this.assertIndex = 0
  this.assertLineNumberMap = {}
  this.AddAssertLine = RBS_TC_AddAssertLine
  this.getTestLineIndex = 0
  this.rawParams = params
  this.paramTestIndex = paramTestIndex 
  this.isParamTest = false
  if (params <> invalid)
    this.name += stri(this.paramTestIndex)
  end if
  return this
end function
function RBS_TC_AddAssertLine(lineNumber as integer)
  m.assertLineNumberMap[stri(m.assertIndex).trim()] = lineNumber
  m.assertIndex++
end function
function RBS_TC_GetAssertLine(testCase, index)
  if (testCase.assertLineNumberMap.doesExist(stri(index).trim()))
    return testCase.assertLineNumberMap[stri(index).trim()]
  else
    return testCase.lineNumber
  end if
end function
function Logger(config) as Object
  this = {}
  this.config = config
  this.verbosityLevel = {
    basic   : 0
    normal  : 1
    verbose : 2   
  }
  this.verbosity        = this.config.logLevel
  this.PrintStatistic     = RBS_LOGGER_PrintStatistic
  this.PrintMetaSuiteStart  = RBS_LOGGER_PrintMetaSuiteStart
  this.PrintSuiteStatistic  = RBS_LOGGER_PrintSuiteStatistic
  this.PrintTestStatistic   = RBS_LOGGER_PrintTestStatistic
  this.PrintStart       = RBS_LOGGER_PrintStart
  this.PrintEnd         = RBS_LOGGER_PrintEnd
  this.PrintSuiteStart    = RBS_LOGGER_PrintSuiteStart
  return this
end function
sub RBS_LOGGER_PrintStatistic(statObj as Object)
  m.PrintStart()
  previousfile = invalid
  for each testSuite in statObj.Suites
    if (not statObj.testRunHasFailures or ((not m.config.showOnlyFailures) OR testSuite.fail > 0 or testSuite.crash > 0))  
      if (testSuite.metaTestSuite.filePath <> previousfile)
        m.PrintMetaSuiteStart(testSuite.metaTestSuite)
        previousfile = testSuite.metaTestSuite.filePath
      end if
      m.PrintSuiteStatistic(testSuite, statObj.testRunHasFailures)
    end if
  end for
  ? ""
  m.PrintEnd()
  ? "Total  = "; RBS_CMN_AsString(statObj.Total); " ; Passed  = "; statObj.Correct; " ; Failed   = "; statObj.Fail; " ; Ignored   = "; statObj.Ignored
  ? " Time spent: "; statObj.Time; "ms"
  ? ""
  ? ""
  if (statObj.ignored > 0)
    ? "IGNORED TESTS:"
    for each ignoredItemName in statObj.IgnoredTestNames
    print ignoredItemName
    end for
  end if
  if (statObj.Total = statObj.Correct)
    overrallResult = "Success"
  else
    overrallResult = "Fail"
  end if
  ? "RESULT: "; overrallResult
end sub
sub RBS_LOGGER_PrintSuiteStatistic(statSuiteObj as Object, hasFailures)
  m.PrintSuiteStart(statSuiteObj.Name)
  for each testCase in statSuiteObj.Tests
    if (not hasFailures or ((not m.config.showOnlyFailures) OR testCase.Result <> "Success"))  
      m.PrintTestStatistic(testCase)
    end if
  end for
  ? " |"
end sub
sub RBS_LOGGER_PrintTestStatistic(testCase as Object)
  metaTestCase = testCase.metaTestCase
  if (LCase(testCase.Result) <> "success")
    testChar = "-"
    assertIndex = metaTestCase.testResult.failedAssertIndex
    locationLine = StrI(RBS_TC_GetAssertLine(metaTestCase,assertIndex)).trim()
  else
    testChar = "|"
    locationLine = StrI(metaTestCase.lineNumber).trim()
  end if
  locationText = testCase.filePath.trim() + "(" + locationLine + ")"
  insetText = ""
  if (not metaTestcase.isParamTest)
    messageLine = RBS_LOGGER_FillText(" " + testChar + " |--" + metaTestCase.Name + " : ", ".", 80)
    ? messageLine ; testCase.Result 
  else if ( metaTestcase.paramTestIndex = 0)
    name = metaTestCase.Name
    if (len(name) > 1 and right(name, 1) = "0")
      name = left(name, len(name) - 1)
    end if
    ? " " + testChar + " |--" + name+ " : "
  end if
  if (metaTestcase.isParamTest)
    insetText = "  "
    messageLine = RBS_LOGGER_FillText(" " + testChar + insetText + " |--" + metaTestCase.rawParams + " : ", ".", 80)
    ? messageLine ; testCase.Result 
  end if
  if LCase(testCase.Result) <> "success"
    ? " | "; insettext ;"  |--Location: "; locationText
    ? " | "; insettext ;"  |--Param Line: "; StrI(metaTestCase.paramlineNumber).trim()
    ? " | "; insettext ;"  |--Error Message: "; testCase.Error.Message
  end if
end sub
function RBS_LOGGER_FillText(text as string, fillChar = " ", numChars = 40) as string
  if (len(text) >= numChars)
    text = left(text, numChars - 5) + "..." + fillChar + fillChar
  else
    numToFill= numChars - len(text) -1
    for i = 0 to numToFill
      text += fillChar
    end for
  end if
  return text
end function
sub RBS_LOGGER_PrintStart()
  ? ""
  ? "[START TEST REPORT]"
  ? ""
end sub
sub RBS_LOGGER_PrintEnd()
  ? ""
  ? "[END TEST REPORT]"
  ? ""
end sub
sub RBS_LOGGER_PrintSuiteSetUp(sName as String)
  if m.verbosity = m.verbosityLevel.verbose
    ? "================================================================="
    ? "===   SetUp "; sName; " suite."
    ? "================================================================="
  end if
end sub
sub RBS_LOGGER_PrintMetaSuiteStart(metaTestSuite)
  ? metaTestSuite.name; " (" ; metaTestSuite.filePath + "(1))"
end sub
sub RBS_LOGGER_PrintSuiteStart(sName as String)
  ? " |-" ; sName
end sub
sub RBS_LOGGER_PrintSuiteTearDown(sName as String)
  if m.verbosity = m.verbosityLevel.verbose
    ? "================================================================="
    ? "===   TearDown "; sName; " suite."
    ? "================================================================="
  end if
end sub
sub RBS_LOGGER_PrintTestSetUp(tName as String)
  if m.verbosity = m.verbosityLevel.verbose
    ? "----------------------------------------------------------------"
    ? "---   SetUp "; tName; " test."
    ? "----------------------------------------------------------------"
  end if
end sub
sub RBS_LOGGER_PrintTestTearDown(tName as String)
  if m.verbosity = m.verbosityLevel.verbose
    ? "----------------------------------------------------------------"
    ? "---   TearDown "; tName; " test."
    ? "----------------------------------------------------------------"
  end if
end sub
function UnitTestResult() as object
  this = {}
  this.messages = CreateObject("roArray", 0, true)
  this.isFail = false
  this.currentAssertIndex = 0
  this.failedAssertIndex = 0
  this.Reset = RBS_TRes_Reset
  this.AddResult = RBS_TRes_AddResult
  this.GetResult = RBS_TRes_GetResult
  return this
end function 
function RBS_TRes_Reset() as void
  m.isFail = false
  m.messages = CreateObject("roArray", 0, true)
end function
function RBS_TRes_AddResult(message as string) as string
  if (message <> "")
    m.messages.push(message)
    if (not m.isFail)
      m.failedAssertIndex = m.currentAssertIndex
    end if
    m.isFail = true
  end if
  m.currentAssertIndex++
  return message  
end function
function RBS_TRes_GetResult() as string
  if (m.isFail)
    msg = m.messages.peek()
    if (msg <> invalid)
      return msg
    else
      return "unknown test failure"
    end if
  else
    return ""
  end if
end function
function RBS_TR_TestRunner(args = {}) as Object
  this = {}
  this.testScene = args.testScene
  fs = CreateObject("roFileSystem")
  defaultConfig = {
    logLevel : 1,
    testsDirectory: "pkg:/source/Tests", 
    testFilePrefix: "Test__",
    failFast: false,
    showOnlyFailures: false,
    maxLinesWithoutSuiteDirective: 100
  }
  rawConfig = invalid
  config = invalid
  if (args.testConfigPath <> invalid and fs.Exists(args.testConfigPath)) 
    ? "Loading test config from " ; args.testConfigPath 
    rawConfig = ReadAsciiFile(args.testConfigPath)
  else if (fs.Exists("pkg:/source/tests/testconfig.json"))
    ? "Loading test config from default location : pkg:/source/tests/testconfig.json" 
    rawConfig = ReadAsciiFile("pkg:/source/tests/testconfig.json")
  else
    ? "None of the testConfig.json locations existed"  
  end if
  if (rawConfig <> invalid)
    config = ParseJson(rawConfig)
  end if
  if (config = invalid or not RBS_CMN_IsAssociativeArray(config) or RBS_CMN_IsNotEmptyString(config.rawtestsDirectory))
    ? "WARNING : specified config is invalid - using default"
    config = defaultConfig  
  end if
  if (args.showOnlyFailures <> invalid)
    config.showOnlyFailures = args.showOnlyFailures = "true"
  end if
  if (args.failFast <> invalid)
    config.failFast = args.failFast = "true"
  end if
  this.testUtilsDecoratorMethodName = args.testUtilsDecoratorMethodName
  this.config = config
  this.config.testsDirectory = config.testsDirectory    
  this.logger = Logger(this.config)
  this.global = args.global
  this.Run          = RBS_TR_Run
  return this
end function
sub RBS_TR_Run()
  totalStatObj = RBS_STATS_CreateTotalStatistic()
  m.runtimeConfig = UnitTestRuntimeConfig(m.config.testsDirectory, m.config.maxLinesWithoutSuiteDirective, m.config.supportLegacyTests = true)
  m.runtimeConfig.global = m.global
  totalStatObj.testRunHasFailures = false
  for each metaTestSuite in m.runtimeConfig.suites
    if (m.runtimeConfig.hasSoloTests )
      if (not metaTestSuite.hasSoloTests)
        if (m.config.logLevel = 2)
          ? "TestSuite " ; metaTestSuite.name ; " Is filtered because it has no solo tests"
        end if 
        goto skipSuite
      end if
    else if (m.runtimeConfig.hasSoloSuites)
      if (not metaTestSuite.isSolo)
        if (m.config.logLevel = 2)
          ? "TestSuite " ; metaTestSuite.name ; " Is filtered due to solo flag"
        end if
        goto skipSuite
      end if
    end if
    if (metaTestSuite.isIgnored)
      if (m.config.logLevel = 2)
        ? "Ignoring TestSuite " ; metaTestSuite.name ; " Due to Ignore flag"
      end if
      totalstatobj.ignored ++
      totalStatObj.IgnoredTestNames.push("|-" + metaTestSuite.name + " [WHOLE SUITE]")
      goto skipSuite
    end if
    if (metaTestSuite.isNodeTest and metaTestSuite.nodeTestFileName <> "")
      ? " +++++RUNNING NODE TEST"
      nodeType = metaTestSuite.nodeTestFileName
      ? " node type is " ; nodeType
      node = m.testScene.CallFunc("Rooibos_CreateTestNode", nodeType)
      if (type(node) = "roSGNode" and node.subType() = nodeType)
        args = {
          "metaTestSuite": metaTestSuite 
          "testUtilsDecoratorMethodName": m.testUtilsDecoratorMethodName 
          "config": m.config 
          "runtimeConfig": m.runtimeConfig
        }
        nodeStatResults = node.callFunc("Rooibos_RunNodeTests", args)
        RBS_STATS_MergeTotalStatistic(totalStatObj, nodeStatResults)
        m.testScene.RemoveChild(node)
      else
        ? " ERROR!! - could not create node required to execute tests for " ; metaTestSuite.name
        ? " Node of type " ; nodeType ; " was not found/could not be instantiated"  
      end if
    else
      if (metaTestSuite.hasIgnoredTests)
        totalStatObj.IgnoredTestNames.push("|-" + metaTestSuite.name)
      end if
      RBS_RT_RunItGroups(metaTestSuite, totalStatObj, m.testUtilsDecoratorMethodName, m.config, m.runtimeConfig)
    end if
    skipSuite:
  end for
  m.logger.PrintStatistic(totalStatObj)
  RBS_TR_SendHomeKeypress()
end sub
sub RBS_RT_RunItGroups(metaTestSuite, totalStatObj, testUtilsDecoratorMethodName, config, runtimeConfig, nodeContext = invalid)
  for each itGroup in metaTestSuite.itGroups
    testSuite = RBS_ItG_GetRunnableTestSuite(itGroup)
    if (nodeContext <> invalid)
      testSuite.node = nodeContext
      testSuite.global = nodeContext.global
      testSuite.top = nodeContext.top
    end if
    if (testUtilsDecoratorMethodName <> invalid)
      testUtilsDecorator = RBS_CMN_GetFunction("RBS_INTERNAL", testUtilsDecoratorMethodName)
      if (RBS_CMN_IsFunction(testUtilsDecorator))
        testUtilsDecorator(testSuite)
      else
        ? "Test utils decorator method `" ; testUtilsDecoratorMethodName ;"` was not in scope!" 
      end if
    end if
    totalStatObj.Ignored += itGroup.ignoredTestCases.count()
    if (itGroup.isIgnored)
      if (config.logLevel = 2)
        ? "Ignoring itGroup " ; itGroup.name ; " Due to Ignore flag"
      end if
      totalStatObj.ignored += itGroup.testCases.count()
      totalStatObj.IgnoredTestNames.push("  |-" + itGroup.name + " [WHOLE GROUP]")
      goto skipItGroup
    else
      if (itGroup.ignoredTestCases.count() > 0)
      totalStatObj.IgnoredTestNames.push("  |-" + itGroup.name)
      totalStatObj.ignored += itGroup.ignoredTestCases.count()
      for each testCase in itGroup.ignoredTestCases
        if (not testcase.isParamTest)
        totalStatObj.IgnoredTestNames.push("  | |--" + testCase.name)
        else if (testcase.paramTestIndex = 0)
        testCaseName = testCase.Name
        if (len(testCaseName) > 1 and right(testCaseName, 1) = "0")
          testCaseName = left(testCaseName, len(testCaseName) - 1)
        end if
        totalStatObj.IgnoredTestNames.push("  | |--" + testCaseName)
        end if
      end for
      end if
    end if
    if (runtimeConfig.hasSoloTests)
      if (not itGroup.hasSoloTests)
        if (config.logLevel = 2)
          ? "Ignoring itGroup " ; itGroup.name ; " Because it has no solo tests"
        end if
        goto skipItGroup
      end if
    else if (runtimeConfig.hasSoloGroups)
      if (not itGroup.isSolo)
        goto skipItGroup
      end if
    end if
    if (testSuite.testCases.Count() = 0)
      if (config.logLevel = 2)
        ? "Ignoring TestSuite " ; itGroup.name ; " - NO TEST CASES"
      end if
      goto skipItGroup
    end if
    if RBS_CMN_IsFunction(testSuite.SetUp)
      testSuite.SetUp()
    end if
    RBS_RT_RunTestCases(metaTestSuite, itGroup, testSuite, totalStatObj, config, runtimeConfig)
    if RBS_CMN_IsFunction(testSuite.TearDown)
      testSuite.TearDown()
    end if
    if (totalStatObj.testRunHasFailures = true and config.failFast = true)
      exit for
    end if
    skipItGroup:
  end for
end sub
sub RBS_RT_RunTestCases(metaTestSuite, itGroup, testSuite, totalStatObj, config, runtimeConfig)
  suiteStatObj = RBS_STATS_CreateSuiteStatistic(itGroup.Name)
  testSuite.global = runtimeConfig.global
  for each testCase in testSuite.testCases
    metaTestCase = itGroup.testCaseLookup[testCase.Name]
    if (runtimeConfig.hasSoloTests and not metaTestCase.isSolo)
      goto skipTestCase
    end if
    if RBS_CMN_IsFunction(testSuite.beforeEach)
      testSuite.beforeEach()
    end if
    testTimer = CreateObject("roTimespan")
    testStatObj = RBS_STATS_CreateTestStatistic(testCase.Name)
    testSuite.testCase = testCase.Func
    testStatObj.filePath = metaTestSuite.filePath
    testStatObj.metaTestCase = metaTestCase
    testSuite.currentResult = UnitTestResult()
    testStatObj.metaTestCase.testResult = testSuite.currentResult
    if (metaTestCase.rawParams <> invalid)
      testCaseParams = invalid
      testCaseParams = parseJson(metaTestCase.rawParams)
      argsValid = RBS_CMN_IsArray(testCaseParams)
      if (argsValid)
        if (testCaseParams.count() = 1)
          testSuite.testCase(testCaseParams[0])
        else if (testCaseParams.count() = 2)
          testSuite.testCase(testCaseParams[0], testCaseParams[1])
        else if (testCaseParams.count() = 3)
          testSuite.testCase(testCaseParams[0], testCaseParams[1], testCaseParams[2])
        else if (testCaseParams.count() = 4)
          testSuite.testCase(testCaseParams[0], testCaseParams[1], testCaseParams[2], testCaseParams[3])
        else if (testCaseParams.count() = 5)
          testSuite.testCase(testCaseParams[0], testCaseParams[1], testCaseParams[2], testCaseParams[3], testCaseParams[4])
        else if (testCaseParams.count() = 6)
          testSuite.testCase(testCaseParams[0], testCaseParams[1], testCaseParams[2], testCaseParams[3], testCaseParams[4], testCaseParams[5])
        end if                              
      else
        ? "Could not parse args for test " ; testCase.name
        testSuite.Fail("Could not parse args for test ")
      end if
    else
      testSuite.testCase()          
    end if
    if testSuite.isAutoAssertingMocks = true
      testSuite.AssertMocks()
      testSuite.CleanMocks()    
      testSuite.CleanStubs()
    end if
    runResult = testSuite.currentResult.GetResult()
    if runResult <> ""
      testStatObj.Result      = "Fail"
      testStatObj.Error.Code    = 1
      testStatObj.Error.Message   = runResult
    else
      testStatObj.Result      = "Success"
    end if
    testStatObj.Time = testTimer.TotalMilliseconds()
    RBS_STATS_AppendTestStatistic(suiteStatObj, testStatObj)
    if RBS_CMN_IsFunction(testSuite.afterEach)
      testSuite.afterEach()
    end if
    if testStatObj.Result <> "Success"
      totalStatObj.testRunHasFailures = true
    end if 
    if testStatObj.Result = "Fail" and config.failFast = true
      exit for
    end if
    skipTestCase:
  end for
  suiteStatObj.metaTestSuite = metaTestSuite
  RBS_STATS_AppendSuiteStatistic(totalStatObj, suiteStatObj)
end sub
sub RBS_TR_SendHomeKeypress()
  ut = CreateObject("roUrlTransfer")
  ut.SetUrl("http://localhost:8060/keypress/Home")
  ut.PostFromString("")
end sub
function Rooibos_RunNodeTests(args) as Object
  ? " RUNNING NODE TESTS"
  totalStatObj = RBS_STATS_CreateTotalStatistic()
  RBS_RT_RunItGroups(args.metaTestSuite, totalStatObj, args.testUtilsDecoratorMethodName, args.config, args.runtimeConfig, m)
  return totalStatObj
end function
Function Rooibos_CreateTestNode(nodeType) as Object
  node = createObject("roSGNode", nodeType)
  if (type(node) = "roSGNode" and node.subType() = nodeType)
  m.top.AppendChild(node)
  return node
  else 
  ? " Error creating test node of type " ; nodeType
  return invalid
  end if
End Function
function UnitTestSuite(filePath as string, maxLinesWithoutSuiteDirective = 100, supportLegacyTests  = false)
  this = {}
  this.filePath = filePath
  this.name = ""
  this.valid = false
  this.hasFailures = false
  this.hasSoloTests = false
  this.hasIgnoredTests = false
  this.hasSoloGroups = false
  this.isSolo = false
  this.isIgnored = false
  this.itGroups = CreateObject("roArray",0, true)
  this.setupFunction = invalid
  this.setupFunctionName = ""
  this.tearDownFunction = invalid
  this.tearDownFunctionName = ""
  this.isNodeTest = false
  this.nodeTestFileName = ""
  this.ProcessSuite = RBS_TS_ProcessSuite
  this.ResetCurrentTestCase = RBS_TS_ResetCurrentTestCase
  this.ProcessLegacySuite = RBS_TS_ProcessLegacySuite  
  this.currentGroup = invalid
  this.groupNames = {}
  this.ProcessSuite(maxLinesWithoutSuiteDirective, supportLegacyTests )
  return this
end function
function RBS_TS_ProcessSuite(maxLinesWithoutSuiteDirective, supportLegacyTests )
  code = RBS_CMN_AsString(ReadAsciiFile(m.filePath))
  isTestSuite = false
  TAG_TEST_SUITE = "'@TestSuite"
  TAG_IT = "'@It"
  TAG_IGNORE = "'@Ignore"
  TAG_SOLO = "'@Only"
  TAG_TEST = "'@Test"
  TAG_NODE_TEST = "'@SGNode"
  TAG_SETUP = "'@Setup"
  TAG_TEAR_DOWN = "'@TearDown"
  TAG_BEFORE_EACH = "'@BeforeEach"
  TAG_AFTER_EACH = "'@AfterEach"
  TAG_TEST_PARAMS = "'@Params"
  TAG_TEST_IGNORE_PARAMS = "'@IgnoreParams"
  TAG_TEST_SOLO_PARAMS = "'@OnlyParams"
  functionNameRegex = CreateObject("roRegex", "^(function|sub)\s([0-9a-z\_]*)\s*\(", "i")
  assertInvocationRegex = CreateObject("roRegex", "^\s*(m.fail|m.Fail|m.assert|m.Assert)(.*)\(", "i")
  functionEndRegex = CreateObject("roRegex", "^\s*(end sub|end function)", "i")
  if code <> ""
    isTokenItGroup = false
    isNextTokenIgnore = false
    isNextTokenSolo = false
    isNextTokenTest = false
    isTestSuite = false
    isNextTokenSetup = false
    isNextTokenTeardown = false
    isNextTokenBeforeEach = false
    isNextTokenAfterEach = false
    isNextTokenNodeTest = false
    isNextTokenTestCaseParam = false
    nodeTestFileName = ""
    nextName = ""
    m.name = m.filePath
    filePathParts = m.filePath.split("/")
    m.filename = filePathParts[filePathParts.count()-1].replace(".brs", "")
    lineNumber = 0
    m.ResetCurrentTestCase()
    currentLocation =""
    for each line in code.Split(chr(10))
      lineNumber++
      currentLocation = m.filePath + ":" + stri(lineNumber)
      if (lineNumber > maxLinesWithoutSuiteDirective and not isTestSuite)
        goto exitProcessing
      end if
      if (RBS_TS_IsTag(line, TAG_TEST_SUITE))
        if (isTestSuite)
          ? "Multiple suites per file are not supported - use '@It tag"
        end if
        name = RBS_TS_GetTagText(line, TAG_TEST_SUITE)
        if (name <> "")
          m.name = name
        end if
        if (isNextTokenSolo)
          m.isSolo = true
          m.name += " [ONLY]"
        end if
        isTestSuite = true
        if (isNextTokenNodeTest)
          m.nodeTestFileName = nodeTestFileName
          m.isNodeTest = true
        end if
        if (isNextTokenIgnore)
          m.isIgnored = true
          goto exitProcessing
        end if
        isNextTokenSolo = false
        isNextTokenIgnore = false
        isNextTokenNodeTest = false
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_IT))
        if (not isTestSuite)
          ? "File not identified as testsuite!"
        end if
        name = RBS_TS_GetTagText(line, TAG_IT)
        if (name = "")
          name = "UNNAMED TAG_TEST GROUP - name this group for better readability - e.g. 'Tests the Load method... '"
        end if
        if (m.groupNames[name] = invalid)
          m.groupNames[name] = 0
        end if
        nameCount = m.groupNames[name]
        nameCount++
        m.groupNames[name] = nameCount
        if (nameCount > 1)
          ? "WARNING A Group already exists with the name '"; name ; " changing name to avoid collisions. New Name:"
          name = "WARNING!! DUPLICATE_" + stri(nameCount - 1).trim() + ": " + name 
          ? name
        end if
        m.currentGroup = UnitTestItGroup(name, isNextTokenSolo, isNextTokenIgnore, m.filename)
        m.currentGroup.setupFunctionName = m.setupFunctionName
        m.currentGroup.setupFunction = m.setupFunction
        m.currentGroup.tearDownFunctionName = m.tearDownFunctionName
        m.currentGroup.tearDownFunction = m.tearDownFunction
        m.currentGroup.beforeEachFunctionName = m.beforeEachFunctionName
        m.currentGroup.beforeEachFunction = m.beforeEachFunction
        m.currentGroup.afterEachFunctionName = m.afterEachFunctionName
        m.currentGroup.afterEachFunction = m.afterEachFunction
        m.itGroups.push(m.currentGroup)
        if (isNextTokenSolo)
          m.hasSoloGroups = true
          m.isSolo = true
        end if
        isTokenItGroup = true       
      else if (RBS_TS_IsTag(line, TAG_SOLO) and not RBS_TS_IsTag(line, TAG_TEST_SOLO_PARAMS))
        if (isNextTokenSolo)
          ? "TAG_TEST MARKED FOR TAG_IGNORE AND TAG_SOLO"
        else 
          isNextTokenSolo = true
        end if
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_IGNORE) and not RBS_TS_IsTag(line, TAG_TEST_IGNORE_PARAMS))
        isNextTokenIgnore = true
        m.hasIgnoredTests = true
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_NODE_TEST))
        if (isTestSuite)
           ? "FOUND " ; TAG_NODE_TEST ; " AFTER '@TestSuite annotation - This test will subsequently not run as a node test. "
           ? "If you wish to run this suite of tests on a node, then make sure the " ; TAG_NODE_TEST ; " annotation appeares before the " ; TAG_TEST_SUITE ; " Annotation"
        end if
        nodeTestFileName = RBS_TS_GetTagText(line, TAG_NODE_TEST)
        isNextTokenNodeTest = true
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_TEST))
        if (not isTestSuite)
          ? "FOUND " ; TAG_TEST; " BEFORE '@TestSuite declaration - skipping test file! "; currentLocation
          goto exitProcessing
        end if
        if (m.currentGroup = invalid)
          ? "FOUND " ; TAG_TEST; " BEFORE '@It declaration - skipping test file!"; currentLocation
          goto exitProcessing
        end if
        m.ResetCurrentTestCase()
        isNextTokenTest = true
        nextName = RBS_TS_GetTagText(line, TAG_TEST)
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_SETUP))
       if (not isTestSuite)
          ? "FOUND " ; TAG_SETUP ; " BEFORE '@TestSuite declaration - skipping test file!"; currentLocation
          goto exitProcessing
        end if
        isNextTokenSetup = true
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_TEAR_DOWN))
        if (not isTestSuite)
          ? "FOUND " ; TAG_TEAR_DOWN ; " BEFORE '@TestSuite declaration - skipping test file!"; currentLocation
          goto exitProcessing
        end if
        isNextTokenTeardown = true
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_BEFORE_EACH))
        if (not isTestSuite)
          ? "FOUND " ; TAG_BEFORE_EACH ; " BEFORE '@TestSuite declaration - skipping test file!"; currentLocation
          goto exitProcessing
        end if
        isNextTokenBeforeEach = true
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_AFTER_EACH))
        if (not isTestSuite)
          ? "FOUND " ; TAG_AFTER_EACH ; " BEFORE '@TestSuite declaration - skipping test file!"; currentLocation
          goto exitProcessing
        end if
        isNextTokenAfterEach = true
        goto exitLoop
      else if (assertInvocationRegex.IsMatch(line))
        if (not m.hasCurrentTestCase)
          ? "Found assert before test case was declared! " ; currentLocation 
        else        
          for testCaseIndex = 0 to m.currentTestCases.count() -1
            tc = m.currentTestCases[testCaseIndex]
            tc.AddAssertLine(lineNumber)
          end for
        end if
        goto exitLoop
      else if (isNextTokenTest and functionEndRegex.IsMatch(line))
        m.ResetCurrentTestCase()
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_TEST_IGNORE_PARAMS))
        isNextTokenTestCaseParam = true ' this keeps the processing going down to the function
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_TEST_PARAMS))
        if (not isNextTokenTest) 
          ? "FOUND " ; TAG_TEST; " PARAM WITHOUT @Test declaration "; currentLocation
        else
          isNextTokenTestCaseParam = true
          rawParams = RBS_TS_GetTagText(line, TAG_TEST_PARAMS)
          m.testCaseParams.push(rawParams)
          m.testCaseParamLines.push(lineNumber)
        end if
        goto exitLoop
      else if (RBS_TS_IsTag(line, TAG_TEST_SOLO_PARAMS))
        if (not isNextTokenTest) 
          ? "FOUND " ; TAG_TEST_SOLO_PARAMS; " PARAM WITHOUT @Test declaration "; currentLocation
        else
          isNextTokenSolo = true
          isNextTokenTestCaseParam = true
          rawParams = RBS_TS_GetTagText(line, TAG_TEST_SOLO_PARAMS)
          m.testCaseOnlyParamLines.push(lineNumber)
          m.testCaseOnlyParams.push(rawParams)
        end if
        goto exitLoop
      end if
      if (isTokenItGroup or isNextTokenTest or isNextTokenSetup or isNextTokenBeforeEach or isNextTokenAfterEach or isNextTokenTeardown)
        if functionNameRegex.IsMatch(line)
          functionName = functionNameRegex.Match(line).Peek()
          functionPointer = RBS_CMN_GetFunction(m.filename, functionName)
          if (functionPointer <> invalid)
            if (isNextTokenTest)
              if (nextName <> "") 
                testName = nextName
              else
                testName = functionName
              end if
              if nodeTestFileName = "" nodeTestFileName = m.nodeTestFileName
              if (m.testCaseParams.count() >0 or m.testCaseOnlyParams.count() >0)
                if (m.testCaseOnlyParams.count() >0)
                  paramsToUse = m.testCaseOnlyParams 
                  paramLineNumbersToUse = m.testCaseOnlyParamLines
                else
                  paramsToUse = m.testCaseParams
                  paramLineNumbersToUse = m.testCaseParamLines
                end if
                for index = 0 to paramsToUse.count() -1
                  params = paramsToUse[index]
                  paramLineNumber = paramLineNumbersToUse[index]  
                  testCase = UnitTestCase(testName, functionPointer, functionName, isNextTokenSolo, isNextTokenIgnore, lineNumber, params, index, paramLineNumber)
                  testCase.isParamTest = true
                  if (testCase <> invalid)
                    m.currentTestCases.push(testCase)
                  else
                    ? "Skipping unparseable params for testcase " ; params ; " @" ; currentLocation
                  end if
                end for
              else
                testCase = UnitTestCase(testName, functionPointer, functionName, isNextTokenSolo, isNextTokenIgnore, lineNumber)
                m.currentTestCases.push(testCase)
              end if              
              for each testCase in m.currentTestCases 
                m.currentGroup.AddTestCase(testCase)
              end for
              m.hasCurrentTestCase = true
              if (isNextTokenSolo)
                m.currentGroup.hasSoloTests = true
                m.hasSoloTests = true
                m.isSolo = true
              end if
              isNextTokenSolo = false
              isNextTokenIgnore = false
              isNextTokenTestCaseParam = false
              isNextTokenTest = false
            else if (isNextTokenSetup)
              if (m.currentGroup = invalid)
                m.setupFunctionName = functionName
                m.setupFunction = functionPointer
              else
                m.currentGroup.setupFunctionName = functionName
                m.currentGroup.setupFunction = functionPointer
              end if 
              isNextTokenSetup = false
            else if (isNextTokenTearDown)
              if (m.currentGroup = invalid)
                m.tearDownFunctionName = functionName
                m.tearDownFunction = functionPointer
              else 
                m.currentGroup.tearDownFunctionName = functionName
                m.currentGroup.tearDownFunction = functionPointer
              end if
              isNextTokenTearDown = false
            else if (isNextTokenBeforeEach)
              if (m.currentGroup = invalid)
                m.beforeEachFunctionName = functionName
                m.beforeEachFunction = functionPointer
              else 
                m.currentGroup.beforeEachFunctionName = functionName
                m.currentGroup.beforeEachFunction = functionPointer
              end if
              isNextTokenBeforeEach = false
            else if (isNextTokenAfterEach)
              if (m.currentGroup = invalid)
                m.afterEachFunctionName = functionName
                m.afterEachFunction = functionPointer
              else 
                m.currentGroup.afterEachFunctionName = functionName
                m.currentGroup.afterEachFunction = functionPointer
              end if
              isNextTokenAfterEach = false
            end if
          else
            ? " could not get function pointer for "; functionName ; " ignoring"
          end if
        else if (isNextTokenSetup)
          ? "could not find function directly after '@Setup - ignoring"
          isNextTokenSetup = false
        else if (isNextTokenTearDown)
          ? "could not find function directly after '@TearDown - ignoring"
          isNextTokenTearDown = false
        else if (isNextTokenBeforeEach)
          ? "could not find function directly after '@BeforeEach - ignoring"
          isNextTokenBeforeEach = false
        else if (isNextTokenAfterEach)
          ? "could not find function directly after '@AfterEach - ignoring"
          isNextTokenAfterEach = false
        else if (isNextTokenSetup)
          ? "could not find setup function - ignoring '@Setup"
          isNextTokenSetup = false
        else if (isTokenItGroup)
          isTokenItGroup = false
          isNextTokenSolo = false
          isNextTokenIgnore = false
        end if
        nodeTestFileName = ""
        nextName = ""
      end if
      exitLoop:
    end for
    exitProcessing:
  else
    ? " Error opening potential test file " ; filePath ; " ignoring..."
  end if
  m.delete("testCaseOnlyParams")
  m.delete("testCaseParams")
  m.delete("currentTestCases")
  m.delete("hasCurrentTestCase")
  if (isTestSuite)
    m.isValid = true
  else if (supportLegacyTests = true)
    m.ProcessLegacySuite(maxLinesWithoutSuiteDirective)
  else
    ? "Ignoring non test/legacy test file "; filePath
    m.isValid = false
  end if
end function
function RBS_TS_IsTag(text, tag) as boolean
  return ucase(Left(text,len(tag))) = ucase(tag)
end function
function RBS_TS_GetTagText(text, tag) as string
  return Mid(text, len(tag) +1).trim()
end function
function RBS_TS_ResetCurrentTestCase() as void
  m.testCaseOnlyParams = []
  m.testCaseParams = []
  m.testCaseParamLines = []
  m.testCaseOnlyParamLines = []
  m.currentTestCases = [] ' we can have multiple test cases based on our params
  m.hasCurrentTestCase = false
end function
function RBS_TS_ProcessLegacySuite(maxLinesWithoutSuiteDirective)
  code = RBS_CMN_AsString(ReadAsciiFile(m.filePath))
  isTestSuite = false
  dblQ = chr(34)
  testSuiteFunctionNameRegex = CreateObject("roRegex", "^\s*(function|sub)\s*testSuite_([0-9a-z\_]*)\s*\(", "i")
  testCaseFunctionNameRegex = CreateObject("roRegex", "^\s*(function|sub)\s*testCase_([0-9a-z\_]*)\s*\(", "i")
  functionNameRegex = CreateObject("roRegex", "^\s*(function|sub)\s([0-9a-z\_]*)\s*\(", "i")
  assertInvocationRegex = CreateObject("roRegex", "^\s*(m.fail|m.Fail|m.assert|m.Assert)(.*)\(", "i")
  functionEndRegex = CreateObject("roRegex", "^\s*(end sub|end function)", "i")
  testSuiteNameRegex = CreateObject("roRegex", "^\s*this\.name\s*=\s*\" + dblQ + "([0-9a-z\_]*)\s*\" + dblQ, "i")
  setupregex = CreateObject("roRegex", "^\s*this\.setup\s*=\s*([a-z_0-9]*)","i")
  addTestregex = CreateObject("roRegex", "^\s*this\.addTest\s*\(\" + dblQ + "([0-9a-z\_]*)\" + dblQ + "\s*,\s*([0-9a-z\_]*)\s*\)", "i")
  TAG_IGNORE = "'@Ignore"
  TAG_SOLO = "'@Only"
  isIgnored = false
  isSolo = false
  if code <> ""
    m.testCaseMap = {} ' map of legacy test cases to function names
    isInInitFunction = false
    isTestSuite = false
    nodeTestFileName = ""
    m.name = m.filePath
    lineNumber = 0
    m.ResetCurrentTestCase()
    currentTestCase = invalid
    currentLocation =""
    for each line in code.Split(chr(10))
      lineNumber++
      currentLocation = m.filePath + ":" + stri(lineNumber)
      if (lineNumber > maxLinesWithoutSuiteDirective and not isTestSuite)
        ? "IGNORING FILE WITH NO testSuiteInit function : "; currentLocation
        goto exitProcessing
      end if
      if (RBS_TS_IsTag(line, TAG_SOLO))
        isSolo = true
        ? " IS SOLO TEST!"
        goto exitLoop
      end if
      if (RBS_TS_IsTag(line, TAG_IGNORE))
        isIgnored = true
        ? " IS IGNORED TEST!"
        goto exitLoop
      end if
      if testSuiteFunctionNameRegex.IsMatch(line)
        isTestSuite = true
        isInInitFunction = true
        goto exitLoop
      end if
      if setupregex.IsMatch(line)
        if not isInInitFunction
          ? "Found test suite setup invocation outside of test suite init function"
          goto exitLoop
        end if
        functionName = setupregex.Match(line).peek()
        functionPointer = RBS_CMN_GetFunction(m.filename, functionName)
        if (functionPointer <> invalid)
          m.setupFunctionName = functionName
          m.setupFunction = functionPointer
        else
          ? " the function name for the setup method "; functionName ; " could not be found"
        end if
        goto exitLoop
      end if     
      if functionEndRegex.IsMatch(line)
        if (isInInitFunction)
          m.currentGroup = UnitTestItGroup(m.name, false, false, m.filename)
          m.currentGroup.setupFunctionName = m.setupFunctionName
          m.currentGroup.setupFunction = m.setupFunction
          m.currentGroup.isLegacy = true
          m.itGroups.push(m.currentGroup)
          isInInitFunction = false
          m.isSolo = isSolo
          m.isIgnored = isIgnored
          isIgnored = false
          isSolo = false
        end if
        currentTestCase = invalid
        goto exitLoop
      end if
      if testSuiteNameRegex.IsMatch(line)
        if (not isInInitFunction)
          ? "Found set testsuite name, when not in a legacy test suite init function. ignoring"
          goto exitLoop
        end if
        name = testSuiteNameRegex.Match(line).Peek()
        if (name <> "")
          m.name = name
        end if
        goto exitLoop
      end if
      if addTestregex.IsMatch(line)
        if (not isInInitFunction)
          ? "Found addTestCase, when not in a legacy test suite init function. Ignoring"
          goto exitLoop
        end if
        match = addTestregex.Match(line)
        testCaseName = match[1]
        testCaseFunctionName = match[2]
        if (testCaseName <> "" and testCaseFunctionName <> "")
          m.testCaseMap[lcase(testCaseFunctionName)] = testCaseName 
        else
        ? " found badly formed add test case function call in test suite init fuction. Ignoring" 
        end if
        goto exitLoop
      end if
      if (assertInvocationRegex.IsMatch(line))
        if (not m.hasCurrentTestCase)
          ? "Found assert before test case was declared! " ; currentLocation 
        else        
          currentTestCase.AddAssertLine(lineNumber)
        end if
        goto exitLoop
      end if
      if testCaseFunctionNameRegex.IsMatch(line)
        if (m.currentGroup = invalid)
          ? " found test case before a group was setup - could be that the init function never terminated"
          goto exitLoop
        end if
        functionName = testCaseFunctionNameRegex.Match(line).peek()
        m.ResetCurrentTestCase()
        if (functionName <> "")
          functionName = "testcase_" + lcase(functionName)
          testName = m.testCaseMap[functionName]
          if (testName = invalid or testName = "")
          print "Encountered test function " ; functionName; " but found no matching AddTestCase invocation"
          goto exitLoop
          end if
          functionPointer = RBS_CMN_GetFunction(m.filename, functionName)
          if (functionPointer <> invalid)
          if nodeTestFileName = "" nodeTestFileName = m.nodeTestFileName
          currentTestCase = UnitTestCase(testName, functionPointer, functionName, isSolo, isIgnored, lineNumber)
          m.currentGroup.AddTestCase(currentTestCase)
          m.hasCurrentTestCase = true
          if (isSolo)
            m.isSolo = true
          end if
          else
            ? " could not get function pointer for "; functionName ; " ignoring"
          end if
        else
          ? " found badly named test case function. ignoring" 
        end if
        isSolo = false
        isIgnored = false
      end if
      exitLoop:
    end for
    exitProcessing:
  else
    ? " Error opening potential test file " ; filePath ; " ignoring..."
  end if
  m.isValid = isTestSuite
end function
