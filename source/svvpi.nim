import std/[os, macros, strutils, strformat, sequtils]
import nimterop/[globals, cimport]

static:
  # Reset old state of searchDirs, symOverride, etc. saved in gStateCT
  # by nimterop. These cause an issue if svdpi is imported before
  # svvpi.
  gStateCT = new(State)

when defined(svGenWrapper):
  static:
    cDisableCaching()
    cDebug()

const
  # includePath = getEnv("XCELIUM_ROOT") / ".." / "include"
  sourceDir = currentSourcePath.parentDir()
  includePath = sourceDir / "includes"
static:
  doAssert fileExists(includePath / "sv_vpi_user.h")
  doAssert fileExists(includePath / "vpi_user.h")
  doAssert fileExists(includePath / "vpi_compatibility.h")
  doAssert fileExists(includePath / "veriuser.h")
  # Put cAddSearchDir in static block: https://github.com/nimterop/nimterop/issues/122
  cAddSearchDir(includePath)

cPlugin:
  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    case sym.name
    # For Nim, the VpiHandle and vpi_handle identifiers are identical.
    # But the vpi_user.h has VpiHandle for type name and vpi_handle for a function
    # name. Below maps the VpiHandle type to VpiHandle in Nim to distinguish the
    # type from vpi_handle.
    of "vpiHandle": sym.name = "VpiHandle"
    # If below substition is not done, nimterop does not infer "PLI_BYTE8 *" type as
    # cstring.
    of "PLI_BYTE8":  sym.name = "cchar"
    # Replacing other similar types just for consistency.
    of "PLI_UBYTE8":  sym.name = "cuchar"
    of "PLI_INT16": sym.name = "cshort"
    of "PLI_UINT16":  sym.name = "cushort"
    of "PLI_INT32": sym.name = "cint"
    of "PLI_UINT32": sym.name = "cuint"
    of "PLI_INT64": sym.name = "clonglong"
    of "PLI_UINT64": sym.name = "culonglong"
    else: discard

cDefine("VPI_COMPATIBILITY_VERSION_1800v2009")

cOverride:
  const
    vpiArrayVar* = vpiRegArray
    vpiArrayNet* = vpiNetArray

# https://github.com/nimterop/nimterop#header-vs-dynlib
#   With --noHeader, types will be pure Nim and procs will be just {.importc.}.
cImport(cSearchPath("sv_vpi_user.h"), recurse = true, flags = "--noHeader -f:ast2")

# The IEEE 1800-2017 standard does not make it clear on what the
# return value of a callback routine should be in the event of success
# vs failure. The only reference I have is an example from Section
# 38.31 vpi_put_data() of the standard.
#
#     PLI_INT32 consumer_restart(p_cb_data data)
#     {
#       // ..
#       if (cnt != vpi_get_data(id, (PLI_BYTE8 *)firstWrk,cnt))
#         return(1); /* error */
#
#       // ..
#       wrk->next = NULL;
#       return(0); /* SUCCESS */
#     }
#
# So I am taking this into my own hands to make it clear and consistent.
const
  vpiCbSuccess* = QuitSuccess.cint # 0
  vpiCbFailure* = QuitFailure.cint # 1

# cImport(cSearchPath("veriuser.h"), recurse = true, flags = "--noHeader -f:ast2") # Mainly for tf_dofinish
proc tf_dofinish*(): cint {.importc, cdecl.}

proc vpiEcho*(format: string): cint {.discardable.} =
  return vpi_printf(format & "\n")

template nilHandleCheck*(handle: VpiHandle; str: string) =
  if handle == nil:
    vpiEcho "Error: " & str & ": nil handle"
    vpiQuit()
    return


# 1800-2009 compatibility
proc vpi_compare_objects*(object1: VpiHandle; object2: VpiHandle): cint =
  return vpi_compare_objects_1800v2009(object1, object2)

# proc vpi_control*(operation: cint): cint {.importc: "vpi_control_1800v2009", cdecl, varargs.}
# https://gitter.im/nim-lang/Nim?at=60ac6967688a2624b8adbdf7
macro unpackVarargs2(callee: untyped; convertproc: untyped; args: varargs[untyped]): untyped =
  result = newCall(callee)
  for arg in args:
    result.add newCall(convertproc, arg)
  # echo result.treeRepr

proc vpiControlArgConvert(inp: int): cint =
  return inp.cint # This is just a placeholder proc for now
template vpi_control*(operation: varargs[typed]): untyped =
  discard unpackVarargs2(vpi_control_1800v2009, vpiControlArgConvert, operation)

proc vpiQuit*(finishArg = 1) =
  # FIXME: -- Mon May 10 02:17:38 EDT 2021 - kmodi
  # vpi_control doesn't seem to work
  # vpi_control(vpiFinish, finishArg)
  discard tf_dofinish()

proc vpi_get*(property: cint; obj: VpiHandle): cint {.exportc, dynlib.} =
  obj.nilHandleCheck("vpi_get")
  return vpi_get_1800v2009(property, obj)
# Add swapped arg version so that we can do obj.vpi_get(property).
proc vpi_get*(obj: VpiHandle; property: cint): cint =
  return vpi_get(property, obj)

proc vpi_get_str*(property: cint; obj: VpiHandle): cstring {.exportc, dynlib.} =
  obj.nilHandleCheck("vpi_get_str")
  return $vpi_get_str_1800v2009(property, obj).cstring
  #      ^ Create a copy of the string on Nim side.
# Add swapped arg version so that we can do obj.vpi_get_str(property).
proc vpi_get_str*(obj: VpiHandle; property: cint): cstring =
  return vpi_get_str(property, obj)

proc vpi_get_value*(expr: VpiHandle; value_p: p_vpi_value) =
  vpi_get_value_1800v2009(expr, value_p)

proc vpi_handle*(typ: cint; refHandle: VpiHandle): VpiHandle {.exportc, dynlib.} =
  return vpi_handle_1800v2009(typ, refHandle)
# Add swapped arg version so that we can do refHandle.vpi_handle(typ).
proc vpi_handle*(refHandle: VpiHandle; typ: cint): VpiHandle =
  return vpi_handle(typ, refHandle)

proc vpi_handle_multi*(typ: cint; refHandle1, refHandle2: VpiHandle): VpiHandle {.importc: "vpi_handle_multi_1800v2009",
                                                                                  cdecl, varargs.}

proc vpi_handle_by_index*(obj: VpiHandle; indx: cint): VpiHandle =
  return vpi_handle_by_index_1800v2009(obj, indx)

proc vpi_handle_by_multiIndex*(obj: VpiHandle; num_index: cint; index_array: ptr cint): VpiHandle =
  return vpi_handle_by_multi_index_1800v2009(obj, num_index, index_array)

proc vpi_iterate*(typ: cint; refHandle: VpiHandle): VpiHandle {.exportc, dynlib.} =
  return vpi_iterate_1800v2009(typ, refHandle)
# Add swapped arg version so that we can do refHandle.vpi_iterate(typ).
proc vpi_iterate*(refHandle: VpiHandle; typ: cint): VpiHandle =
  return vpi_iterate(typ, refHandle)

proc vpi_put_value*(obj: VpiHandle; value_p: p_vpi_value; time_p: p_vpi_time; flags: cint): VpiHandle =
  return vpi_put_value_1800v2009(obj, value_p, time_p, flags)

proc vpi_register_cb*(cb_data_p: p_cb_data): VpiHandle =
  return vpi_register_cb_1800v2009(cb_data_p)

proc vpi_scan*(iter: VpiHandle): VpiHandle {.exportc, dynlib.} =
  return vpi_scan_1800v2009(iter)

proc vpi_handle_by_name*(name: cstring; scope: VpiHandle): VpiHandle {.exportc, dynlib.} =
  result = vpi_handle_by_name_1800v2009(name, scope)
  if result == nil:
    vpiEcho &"Error: vpi_handleByName: Cannot find an object by name '{name}'"
    vpiQuit()
# Add swapped arg version so that we can do scope.vpi_handle_by_name(name).
proc vpi_handle_by_name*(scope: VpiHandle; name: cstring): VpiHandle =
  return vpi_handle_by_name(name, scope)


# https://forum.nim-lang.org/t/7945#50584
# User code must call this template at global scope, and only once!
template setVlogStartupRoutines*(procArray: varargs[proc() {.nimcall.}]) =
  const
    numProcs = procArray.len
  var
    # The `vlog_startup_routines` identifier below is special and needs to
    # match exactly to match this declaration in vpi_user.h:
    #   PLI_VEXTERN PLI_DLLESPEC void (*vlog_startup_routines[]) ();
    vlog_startup_routines {.inject, exportc, dynlib.}: array[numProcs + 1, proc() {.nimcall.}]
  for i in 0 ..< numProcs:
    vlog_startup_routines[i] = procArray[i]
  vlog_startup_routines[numProcs] = nil

type
  VpiError* = object of Exception
  VpiTfError* = object of VpiError
  VpiCheckError* = object of VpiError

proc vpiQuitOnException*(systfHandle: VpiHandle) =
  vpiEcho getCurrentExceptionMsg()
  vpiQuit()

template vpiException*(error: string) =
  let
    lineNo = vpi_get(vpiLineNo, systfHandle)
  raise newException(VpiTfError, "ERROR: $#: Line $#: $#" % [tfName, $lineNo, error])

proc vpiCheckError*() =
  ## Prints an error message if the previous VPI API call resulted in an error.
  var
    errorInfo = t_vpi_error_info()
  if vpi_chk_error(addr errorInfo) != 0:
    var
      raiseException = false
      msg: string
      lineInfo = ""
    let
      state = case errorInfo.state
              of 1: "Compile"
              of 2: "PLI"
              of 3: "Run"
              else: ""
      severity = case errorInfo.level
                 of 1: "N" # Notice
                 of 2: "W" # Warning
                 of 3:
                   raiseException = true
                   "E" # Error
                 of 4:
                   raiseException = true
                   "F" # System
                 of 5:
                   raiseException = true
                   "I" # Internal
                 else: ""
    if errorInfo.line != 0:
      lineInfo = &" ({errorInfo.file}:{errorInfo.line})"
    msg = &"{errorInfo.product} {state}: *{severity},{errorInfo.code}{lineInfo}: {errorInfo.message}"

    if raiseException:
      raise newException(VpiCheckError, msg)
    else:
      vpiEcho(msg)

template createTfProc(procSym: untyped; body: untyped) =
  # Below proc needs to have the signature "proc (a1: cstring): cint
  # {.cdecl.}"  as that's what nimterop auto-parses the
  # `t_vpi_systf_data.compiletf`, `t_vpi_systf_data.calltf`,
  # etc. types to.
  proc `procSym`(userData: cstring): cint {.cdecl.} =
    let
      userData {.inject.} = userData # https://forum.nim-lang.org/t/3964#24706
    var
      systfHandle {.inject.}: VpiHandle
    try:
      systfHandle = vpi_handle(vpiSysTfCall, nil)
      if systfHandle == nil:
        vpiException &"Failed to obtain systf handle"
      body
    except VpiError:
      systfHandle.vpiQuitOnException()

macro vpiDefine*(exps: varargs[untyped]): untyped =
  const
    validKeywords = ["task", "function"]
  var
    validKeys: seq[string]
    tfKeyword: string
    tfType: cint
    procSym: NimNode
    tfName: string # Marking this global so that it can be captured inside cdecl procs compiletf, calltf, etc.
    keyword: string
    setupNode = newEmptyNode()
    compiletfSym = newNilLit()
    calltfSym = newNilLit()
    sizetfSym = newNilLit()
    tfProcNodes = newStmtList()
    functypeNode = ident("vpiIntFunc") # Default the sys func return types to be int
    userdataNode = newNilLit()
    moreNode = newEmptyNode()

  when defined(debug):
    echo "exps len = $#" % [$exps.len]
  # Minimal macro call:
  #   vpiDefine task bye:       <- exps[0]
  #     calltf:                 <- exps[1]
  #       vpiEcho "In calltf"
  exps.expectLen(2)
  for i, e0 in exps:
    when defined(debug):
      echo "exps[$#]: $#"       % [$i, e0.repr]
      echo "exps[$#] kind = $#" % [$i, $e0.kind]
      echo "exps[$#] len = $#"  % [$i, $e0.len]

    case i
    of 0:
      #     Command
      #       Ident "task"
      #       Ident "bye"
      e0.expectKind(nnkCommand)
      e0.expectLen(2)
      for j, e1 in e0:
        when defined(debug):
          echo "  exps[$#][$#]: $#"       % [$i, $j, e1.repr]
          echo "  exps[$#][$#] kind = $#" % [$i, $j, $e1.kind]
          echo "  exps[$#][$#] len = $#"  % [$i, $j, $e1.len]
        e1.expectKind(nnkIdent)

        case j
        of 0:
          tfKeyword = $e1
          if not validKeywords.anyIt(it == tfKeyword):
            error "The keyword should be one of $#, but '$#' was found" % [$validKeywords, tfKeyword]
          validKeys = @["setup", "compiletf", "calltf", "userdata", "more"]
          if tfKeyword == "task":
            tfType = vpiSysTask
          else:
            tfType = vpiSysFunc
            validKeys.add("sizetf")
            validKeys.add("functype")
        of 1:
          procSym = e1
          tfName = "$" & $e1 # This must always begin with "$".
          when defined(debug):
            echo "  $# $#" % [tfKeyword, tfName]
        else:
          quit QuitFailure # unreachable

    of 1:
      e0.expectKind(nnkStmtList)
      e0.expectMinLen(1) # At least a calltf should be defined.
      for j, e1 in e0:
        when defined(debug):
          echo "  exps[$#][$#]: $#"       % [$i, $j, e1.repr]
          echo "  exps[$#][$#] kind = $#" % [$i, $j, $e1.kind]
          echo "  exps[$#][$#] len = $#"  % [$i, $j, $e1.len]

        e1.expectKind({nnkCommentStmt, nnkCall})
        if e1.kind == nnkCommentStmt:
          continue # We don't need to do any parsing of the doc strings

        # e1 should be of nnkCall kind here, e.g. compiletf:, calltf:, ..
        e1.expectLen(2)
        for k, e2 in e1:
          when defined(debug):
            echo "    exps[$#][$#][$#]: $#"       % [$i, $j, $k, e2.repr]
            echo "    exps[$#][$#][$#] kind = $#" % [$i, $j, $k, $e2.kind]
            echo "    exps[$#][$#][$#] len = $#"  % [$i, $j, $k, $e2.len]

          case k
          of 0:
            e2.expectKind(nnkIdent) # Should be compiletf, calltf, ..
            keyword = $e2
            if not validKeys.anyIt(it == toLowerAscii(keyword)):
              error "The key should be one of $# for a $#, but '$#' was found" % [$validKeys, tfKeyword, keyword]
          of 1:
            e2.expectKind(nnkStmtList)

            case keyword
            of "setup":
              setupNode = e2

            of "compiletf":
              compiletfSym = ident(keyword)
              tfProcNodes.add quote do:
                createTfProc(compiletf, `e2`)

            of "calltf":
              calltfSym = ident(keyword)
              tfProcNodes.add quote do:
                createTfProc(calltf, `e2`)

            of "sizetf":
              sizetfSym = ident(keyword)
              # It's safe to assume that if the user used 'sizetf',
              # they would want the func return type to be sized. The
              # return type is assumed to be vpiSizedFunc in that
              # case.
              if functypeNode == ident("vpiIntFunc"):
                functypeNode = ident("vpiSizedFunc")
              tfProcNodes.add quote do:
                proc sizetf(userData: cstring): cint {.cdecl.} =
                  let
                    userData {.inject.} = userData # https://forum.nim-lang.org/t/3964#24706
                  `e2`

            of "functype":
              functypeNode = e2

            of "userdata":
              userdataNode = e2

            of "more":
              moreNode = e2

            else:
              quit QuitFailure # unreachable
          else:
            quit QuitFailure # unreachable
    else:
      quit QuitFailure # unreachable
    when defined(debug):
      echo ""

  result = quote do:
    proc `procSym`*() =
      const
        tfName {.inject.} = `tfName`
      `setupNode`
      `tfProcNodes`
      var
        taskDataObj = s_vpi_systf_data(type: `tfType`,
                                       tfname: `tfName`,
                                       compiletf: `compiletfSym`,
                                       calltf: `calltfSym`,
                                       sysfunctype: `functypeNode`,
                                       sizetf: `sizetfSym`,
                                       user_data: `userdataNode`)

      # TODO: Add support for registering callbacks.
      discard vpi_register_systf(addr taskDataObj)
      `moreNode`

## Iterators
iterator vpiHandles2*(systfHandle: VpiHandle; typ: int; allowNilYield = false; checkError = false): (VpiHandle, VpiHandle) =
  ## Yields (handle of element pointed by iterator, iterator handle).
  let
    iterHandle = systfHandle.vpi_iterate(typ.cint)
  if checkError:
    vpiCheckError()

  if allowNilYield and iterHandle == nil:
    yield (nil, nil)
  while iterHandle != nil:
    let
      elemHandle = vpi_scan(iterHandle)
    if checkError:
      vpiCheckError()
    if not allowNilYield and elemHandle == nil:
      # This is where the vpi_scan returns nil.
      # The iterator object is freed up automatically
      # at this point and we just break out of the iter.
      break
    yield (elemHandle, iterHandle) # Need to return the iterHandle in case
                                   # the application needs to free its memory
    if elemHandle == nil:
      break

iterator vpiHandles2*(systfHandle: VpiHandle; types: openArray[int]; allowNilYield = false; checkError = false): (VpiHandle, VpiHandle) =
  for typ in types:
    for argHandle, iterHandle in systfHandle.vpiHandles2(typ, allowNilYield, checkError):
      yield (argHandle, iterHandle)

iterator vpiHandles3*(systfHandle: VpiHandle; typ: int; allowNilYield = false; checkError = false): (int, VpiHandle, VpiHandle) =
  ## Yields (index, handle of element pointed by iterator, iterator handle).
  var
    index = 0
  for argHandle, iterHandle in systfHandle.vpiHandles2(typ, allowNilYield, checkError):
    yield (index, argHandle, iterHandle)
    inc index

iterator vpiHandles3*(systfHandle: VpiHandle; types: openArray[int]; allowNilYield = false; checkError = false): (int, VpiHandle, VpiHandle) =
  for typ in types:
    for argIndex, argHandle, iterHandle in systfHandle.vpiHandles3(typ, allowNilYield, checkError):
      yield (argIndex, argHandle, iterHandle)

iterator vpiArgs*(systfHandle: VpiHandle; allowNilYield = false; checkError = false): (int, VpiHandle) =
  ## Yields (argument index, argument handle).
  for argIndex, argHandle, _ in systfHandle.vpiHandles3(vpiArgument, allowNilYield, checkError):
    yield (argIndex, argHandle)

proc vpiIsFirstArgNullOp*(argHandle: VpiHandle; maxNumArgs: int): bool =
  if maxNumArgs == 0 and
     vpi_get(vpiType, argHandle) in {vpiOperation} and
     vpi_get(vpiOpType, argHandle) in {vpiNullOp}:
    # For $foo() in SV, the '()' is inferred as an arg of type
    # vpiOperation->vpiNullOp. For practical purposes, we will
    # consider that as "no arg".
    return true

template vpiNumArgCheck*(systfHandle: VpiHandle; numArgRange: Slice[int]) =
  ## tfName, a string variable needs to be declared in the scope where
  ## this template is called.
  let
    minNumArgs = min(numArgRange.a, numArgRange.b)
    maxNumArgs = max(numArgRange.a, numArgRange.b)
    reqArgsStr = if numArgRange.a == numArgRange.b:
                   $numArgRange.a
                 else:
                   "$# to $#" % [$minNumArgs, $maxNumArgs]
  for argIndex, argHandle, iterHandle in systfHandle.vpiHandles3(vpiArgument, allowNilYield = true):
    if iterHandle == nil: # This is happen only when argIndex == 0
      if 0 notin numArgRange:
        vpiException "Requires $# arguments, but has none" % [reqArgsStr]
    elif argHandle == nil: # iterHandle is non-nil
      if argIndex notin numArgRange:
        vpiException "Requires $# arguments, but has only $#" % [reqArgsStr, $argIndex]
    else: # Both iterHandle and argHandle are non-nil
      # echo "arg $# type = $#" % [$argIndex, $vpi_get(vpiType, argHandle)]
      if argIndex >= maxNumArgs:
        discard vpi_release_handle(iterHandle) # free iterator memory
        if argHandle.vpiIsFirstArgNullOp(maxNumArgs):
          break
        vpiException "Requires $# arguments, but more (at least $#) were detected" % [reqArgsStr, $(argIndex+1)]

template vpiNumArgCheck*(systfHandle: VpiHandle; numArgs: int) =
  vpiNumArgCheck(systfHandle, numArgs .. numArgs)
