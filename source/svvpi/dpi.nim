import std/[strformat]
import svvpi

proc vpiGetValue*[T](handle: VpiHandle; format: cint): T =
  handle.nilHandleCheck("vpiGetValue")

  var
    v = s_vpi_value(format: format)
  vpi_get_value(handle, addr v)

  case format
  of vpiIntVal: return v.value.integer.T
  else: discard

proc vpi_get_value_int*(handle: VpiHandle): cint {.exportc, dynlib.} =
  return vpiGetValue[cint](handle, vpiIntVal)

proc vpiPutValue*[T](handle: VpiHandle; format: cint; value: T) =
  handle.nilHandleCheck("vpiPutValue")

  var
    v = s_vpi_value(format: format)

  case format
  of vpiIntVal: v.value.integer = value
  else: discard

  discard vpi_put_value(handle, addr v, nil, vpiNoDelay)

proc vpi_put_value_int*(handle: VpiHandle; value: cint) {.exportc, dynlib.} =
  vpiPutValue[cint](handle, vpiIntVal, value)
