// Time-stamp: <2021-05-13 13:12:56 kmodi>
//
// -------------------------------------------------------------------
// Project            : svvpi
// File Name          : vpi_pkg.sv
// Original Author    : Kaushal.Modi@gmail.com
// Description        : SystemVerilog package for VPI types
// -------------------------------------------------------------------

package vpi_pkg;

  typedef byte signed   int8_t;
  typedef byte unsigned uint8_t;

  typedef shortint signed   int16_t;
  typedef shortint unsigned uint16_t;

  typedef int signed   int32_t;
  typedef int unsigned uint32_t;

  typedef longint signed   int64_t;
  typedef longint unsigned uint64_t;

  // Object types
  typedef enum { vpiAlways = 1                // always procedure
                 , vpiAssignStmt = 2          // quasi-continuous assignment
                 , vpiAssignment = 3          // procedural assignment
                 , vpiBegin = 4               // block statement
                 , vpiCase = 5                // case statement
                 , vpiCaseItem = 6            // case statement item
                 , vpiConstant = 7            // numerical constant or string literal
                 , vpiContAssign = 8          // continuous assignment
                 , vpiDeassign = 9            // deassignment statement
                 , vpiDefParam = 10           // defparam
                 , vpiDelayControl = 11       // delay statement (e.g., #10)
                 , vpiDisable = 12            // named block disable statement
                 , vpiEventControl = 13       // wait on event, e.g., @e
                 , vpiEventStmt = 14          // event trigger, e.g., ->e
                 , vpiFor = 15                // for statement
                 , vpiForce = 16              // force statement
                 , vpiForever = 17            // forever statement
                 , vpiFork = 18               // fork-join block
                 , vpiFuncCall = 19           // function call
                 , vpiFunction = 20           // function
                 , vpiGate = 21               // primitive gate
                 , vpiIf = 22                 // if statement
                 , vpiIfElse = 23             // if-else statement
                 , vpiInitial = 24            // initial procedure
                 , vpiIntegerVar = 25         // integer variable
                 , vpiInterModPath = 26       // intermodule wire delay
                 , vpiIterator = 27           // iterator
                 , vpiIODecl = 28             // input/output declaration
                 , vpiMemory = 29             // behavioral memory
                 , vpiMemoryWord = 30         // single word of memory
                 , vpiModPath = 31            // module path for path delays
                 , vpiModule = 32             // module instance
                 , vpiNamedBegin = 33         // named block statement
                 , vpiNamedEvent = 34         // event variable
                 , vpiNamedFork = 35          // named fork-join block
                 , vpiNet = 36                // scalar or vector net
                 , vpiNetBit = 37             // bit of vector net
                 , vpiNullStmt = 38           // a semicolon. Ie. #10 ;
                 , vpiOperation = 39          // behavioral operation
                 , vpiParamAssign = 40        // module parameter assignment
                 , vpiParameter = 41          // module parameter
                 , vpiPartSelect = 42         // part-select
                 , vpiPathTerm = 43           // terminal of module path
                 , vpiPort = 44               // module port
                 , vpiPortBit = 45            // bit of vector module port
                 , vpiPrimTerm = 46           // primitive terminal
                 , vpiRealVar = 47            // real variable
                 , vpiReg = 48                // scalar or vector reg
                 , vpiRegBit = 49             // bit of vector reg
                 , vpiRelease = 50            // release statement
                 , vpiRepeat = 51             // repeat statement
                 , vpiRepeatControl = 52      // repeat control in an assign stmt
                 , vpiSchedEvent = 53         // vpi_put_value() event
                 , vpiSpecParam = 54          // specparam
                 , vpiSwitch = 55             // transistor switch
                 , vpiSysFuncCall = 56        // system function call
                 , vpiSysTaskCall = 57        // system task call
                 , vpiTableEntry = 58         // UDP state table entry
                 , vpiTask = 59               // task
                 , vpiTaskCall = 60           // task call
                 , vpiTchk = 61               // timing check
                 , vpiTchkTerm = 62           // terminal of timing check
                 , vpiTimeVar = 63            // time variable
                 , vpiTimeQueue = 64          // simulation event queue
                 , vpiUdp = 65                // user-defined primitive
                 , vpiUdpDefn = 66            // UDP definition
                 , vpiUserSystf = 67          // user-defined system task/function
                 , vpiVarSelect = 68          // variable array selection
                 , vpiWait = 69               // wait statement
                 , vpiWhile = 70              // while statement

                 // object types added with 1364-2001
                 , vpiAttribute = 105         // attribute of an object
                 , vpiBitSelect = 106         // Bit-select of parameter, var select
                 , vpiCallback = 107          // callback object
                 , vpiDelayTerm = 108         // Delay term which is a load or driver
                 , vpiDelayDevice = 109       // Delay object within a net
                 , vpiFrame = 110             // reentrant task/func frame
                 , vpiGateArray = 111         // gate instance array
                 , vpiModuleArray = 112       // module instance array
                 , vpiPrimitiveArray = 113    // vpiprimitiveArray type
                 , vpiNetArray = 114          // multidimensional net
                 , vpiRange = 115             // range declaration
                 , vpiRegArray = 116          // multidimensional reg
                 , vpiSwitchArray = 117       // switch instance array
                 , vpiUdpArray = 118          // UDP instance array
                 , vpiContAssignBit = 128     // Bit of a vector continuous assignment
                 , vpiNamedEventArray = 129   // multidimensional named event

                 // object types added with 1364-2005
                 , vpiIndexedPartSelect = 130 // Indexed part-select object
                 , vpiGenScopeArray = 133     // array of generated scopes
                 , vpiGenScope = 134          // A generated scope
                 , vpiGenVar = 135            // Object used to instantiate gen scopes
                 } vpi_object_type_e;

  // Methods
  typedef enum {
                // Methods used to traverse 1 to 1 relationships
                vpiCondition = 71      // condition expression
                , vpiDelay = 72        // net or gate delay
                , vpiElseStmt = 73     // else statement
                , vpiForIncStmt = 74   // increment statement in for loop
                , vpiForInitStmt = 75  // initialization statement in for loop
                , vpiHighConn = 76     // higher connection to port
                , vpiLhs = 77          // left-hand side of assignment
                , vpiIndex = 78        // index of var select, bit-select, etc.
                , vpiLeftRange = 79    // left range of vector or part-select
                , vpiLowConn = 80      // lower connection to port
                , vpiParent = 81       // parent object
                , vpiRhs = 82          // right-hand side of assignment
                , vpiRightRange = 83   // right range of vector or part-select
                , vpiScope = 84        // containing scope object
                , vpiSysTfCall = 85    // task function call
                , vpiTchkDataTerm = 86 // timing check data term
                , vpiTchkNotifier = 87 // timing check notifier
                , vpiTchkRefTerm = 88  // timing check reference term

                // Methods used to traverse 1 to many relationships
                , vpiArgument = 89        // argument to (system) task/function
                , vpiBit = 90             // bit of vector net or port
                , vpiDriver = 91          // driver for a net
                , vpiInternalScope = 92   // internal scope in module
                , vpiLoad = 93            // load on net or reg
                , vpiModDataPathIn = 94   // data terminal of a module path
                , vpiModPathIn = 95       // Input terminal of a module path
                , vpiModPathOut = 96      // output terminal of a module path
                , vpiOperand = 97         // operand of expression
                , vpiPortInst = 98        // connected port instance
                , vpiProcess = 99         // process in module
                , vpiVariables = 100      // variables in module
                , vpiUse = 101            // usage

                // Methods which can traverse 1 to 1, or 1 to many relationships
                , vpiExpr = 102        // connected expression
                , vpiPrimitive = 103   // primitive (gate, switch, UDP)
                , vpiStmt = 104        // statement in process or task

                // Methods added with 1364-2001
                , vpiActiveTimeFormat = 119   // active $timeformat() system task
                , vpiInTerm = 120             // To get to a delay device's drivers.
                , vpiInstanceArray = 121      // vpiInstance arrays
                , vpiLocalDriver = 122        // local drivers (within a module
                , vpiLocalLoad = 123          // local loads (within a module
                , vpiOutTerm = 124            // To get to a delay device's loads.
                , vpiPorts = 125              // Module port
                , vpiSimNet = 126             // simulated net after collapsing
                , vpiTaskFunc = 127           // task/function

                // Methods added with 1364-2005
                , vpiBaseExpr = 131    // Indexed part-select's base expression
                , vpiWidthExpr = 132   // Indexed part-select's width expression

                // Methods added with 1800-2009
                , vpiAutomatics = 136  // Automatic variables of a frame
                } vpi_methods_e;

  // Properties

  // Sub-properties of vpiUnconnDrive
  typedef enum { vpiHighZ = 1            // No default drive given
                 , vpiPull1 = 2          // default pull1 drive
                 , vpiPull0 = 3          // default pull0 drive
                 } vpi_unconn_drive_e;

  // Sub-properties of vpiDefDelayMode
  typedef enum { vpiDelayModeNone = 1      // no delay mode specified
                 , vpiDelayModePath = 2    // path delay mode
                 , vpiDelayModeDistrib = 3 // distributed delay mode
                 , vpiDelayModeUnit = 4    // unit delay mode
                 , vpiDelayModeZero = 5    // zero delay mode
                 , vpiDelayModeMTM = 6     // min:typ:max delay mode
                 } vpi_def_delay_mode_e;

  // Sub-properties of vpiDirection
  typedef enum { vpiInput = 1           // input
                 , vpiOutput = 2        // output
                 , vpiInout = 3         // inout
                 , vpiMixedIO = 4       // mixed input-output
                 , vpiNoDirection = 5   // no direction
                 } vpi_direction_e;

  // Sub-properties of vpiNetType
  typedef enum { vpiWire = 1         // wire net
                 , vpiWand = 2       // wire-and net
                 , vpiWor = 3        // wire-or net
                 , vpiTri = 4        // three-state net
                 , vpiTri0 = 5       // pull-down net
                 , vpiTri1 = 6       // pull-up net
                 , vpiTriReg = 7     // three-state reg net
                 , vpiTriAnd = 8     // three-state wire-and net
                 , vpiTriOr = 9      // three-state wire-or net
                 , vpiSupply1 = 10   // supply-1 net
                 , vpiSupply0 = 11   // supply-0 net
                 , vpiNone = 12      // no default net type (1364-2001)
                 , vpiUwire = 13     // unresolved wire net (1364-2005)
                 } vpi_net_type_e;

  // Sub-properties of vpiPrimType
  typedef enum { vpiAndPrim = 1           // and gate
                 , vpiNandPrim = 2        // nand gate
                 , vpiNorPrim = 3         // nor gate
                 , vpiOrPrim = 4          // or gate
                 , vpiXorPrim = 5         // xor gate
                 , vpiXnorPrim = 6        // xnor gate
                 , vpiBufPrim = 7         // buffer
                 , vpiNotPrim = 8         // not gate
                 , vpiBufif0Prim = 9      // zero-enabled buffer
                 , vpiBufif1Prim = 10     // one-enabled buffer
                 , vpiNotif0Prim = 11     // zero-enabled not gate
                 , vpiNotif1Prim = 12     // one-enabled not gate
                 , vpiNmosPrim = 13       // nmos switch
                 , vpiPmosPrim = 14       // pmos switch
                 , vpiCmosPrim = 15       // cmos switch
                 , vpiRnmosPrim = 16      // resistive nmos switch
                 , vpiRpmosPrim = 17      // resistive pmos switch
                 , vpiRcmosPrim = 18      // resistive cmos switch
                 , vpiRtranPrim = 19      // resistive bidirectional
                 , vpiRtranif0Prim = 20   // zero-enable resistive bidirectional
                 , vpiRtranif1Prim = 21   // one-enable resistive bidirectional
                 , vpiTranPrim = 22       // bidirectional
                 , vpiTranif0Prim = 23    // zero-enabled bidirectional
                 , vpiTranif1Prim = 24    // one-enabled bidirectional
                 , vpiPullupPrim = 25     // pullup
                 , vpiPulldownPrim = 26   // pulldown
                 , vpiSeqPrim = 27        // sequential UDP
                 , vpiCombPrim = 28       // combinational UDP
                 } vpi_prim_type_e;

  // Sub-properties of vpiDataPolarity
  typedef enum { vpiPositive = 1    // positive
                 , vpiNegative = 2  // negative
                 , vpiUnknown = 3   // unknown (unspecified)
                 } vpi_data_polarity_e;

  // Sub-properties of vpiEdge
  typedef enum { vpiNoEdge = 'h00     // no edge
                 , vpiEdge01 = 'h01   // 0 -> 1
                 , vpiEdge10 = 'h02   // 1 -> 0
                 , vpiEdge0x = 'h04   // 0 -> x
                 , vpiEdgex1 = 'h08   // x -> 1
                 , vpiEdge1x = 'h10   // 1 -> x
                 , vpiEdgex0 = 'h20   // x -> 0
                 } vpi_edge_e;

  function bit vpiPosedge(input vpi_edge_e e_type);
    return e_type inside {vpiEdgex1, vpiEdge01, vpiEdge0x};
  endfunction : vpiPosedge

  function bit vpiNegedge(input vpi_edge_e e_type);
    return e_type inside {vpiEdgex0, vpiEdge10, vpiEdge1x};
  endfunction : vpiNegedge

  function bit vpiAnyEdge(input vpi_edge_e e_type);
    return (vpiPosedge(e_type) | vpiNegedge(e_type));
  endfunction : vpiAnyEdge

  // Sub-properties of vpiPathType
  typedef enum { vpiPathFull = 1        // ( a *> b )
                 , vpiPathParallel = 2  // ( a => b )
                 } _e;

  // Sub-properties of vpiTchkType
  typedef enum { vpiSetup = 1         // $setup
                 , vpiHold = 2        // $hold
                 , vpiPeriod = 3      // $period
                 , vpiWidth = 4       // $width
                 , vpiSkew = 5        // $skew
                 , vpiRecovery = 6    // $recovery
                 , vpiNoChange = 7    // $nochange
                 , vpiSetupHold = 8   // $setuphold
                 , vpiFullskew = 9    // $fullskew -- added for 1364-2001
                 , vpiRecrem = 10     // $recrem   -- added for 1364-2001
                 , vpiRemoval = 11    // $removal  -- added for 1364-2001
                 , vpiTimeskew = 12   // $timeskew -- added for 1364-2001
                 } vpi_tchk_type_e;

  // Sub-properties of vpiOpType
  typedef enum { vpiMinusOp = 1                // unary minus
                 , vpiPlusOp = 2               // unary plus
                 , vpiNotOp = 3                // unary not
                 , vpiBitNegOp = 4             // bitwise negation
                 , vpiUnaryAndOp = 5           // bitwise reduction and
                 , vpiUnaryNandOp = 6          // bitwise reduction nand
                 , vpiUnaryOrOp = 7            // bitwise reduction or
                 , vpiUnaryNorOp = 8           // bitwise reduction nor
                 , vpiUnaryXorOp = 9           // bitwise reduction xor
                 , vpiUnaryXNorOp = 10         // bitwise reduction xnor
                 , vpiSubOp = 11               // binary subtraction
                 , vpiDivOp = 12               // binary division
                 , vpiModOp = 13               // binary modulus
                 , vpiEqOp = 14                // binary equality
                 , vpiNeqOp = 15               // binary inequality
                 , vpiCaseEqOp = 16            // case (x and z) equality
                 , vpiCaseNeqOp = 17           // case inequality
                 , vpiGtOp = 18                // binary greater than
                 , vpiGeOp = 19                // binary greater than or equal
                 , vpiLtOp = 20                // binary less than
                 , vpiLeOp = 21                // binary less than or equal
                 , vpiLShiftOp = 22            // binary left shift
                 , vpiRShiftOp = 23            // binary right shift
                 , vpiAddOp = 24               // binary addition
                 , vpiMultOp = 25              // binary multiplication
                 , vpiLogAndOp = 26            // binary logical and
                 , vpiLogOrOp = 27             // binary logical or
                 , vpiBitAndOp = 28            // binary bitwise and
                 , vpiBitOrOp = 29             // binary bitwise or
                 , vpiBitXorOp = 30            // binary bitwise xor
                 , vpiBitXnorOp = 31           // binary bitwise xnor
                 , vpiConditionOp = 32         // ternary conditional
                 , vpiConcatOp = 33            // n-ary concatenation
                 , vpiMultiConcatOp = 34       // repeated concatenation
                 , vpiEventOrOp = 35           // event or
                 , vpiNullOp = 36              // null operation
                 , vpiListOp = 37              // list of expressions
                 , vpiMinTypMaxOp = 38         // min:typ:max: delay expression
                 , vpiPosedgeOp = 39           // posedge
                 , vpiNegedgeOp = 40           // negedge
                 , vpiArithLShiftOp = 41       // arithmetic left shift  (1364-2001)
                 , vpiArithRShiftOp = 42       // arithmetic right shift (1364-2001)
                 , vpiPowerOp = 43             // arithmetic power op    (1364-2001)
                 } vpi_op_type_e;

  // Sub-properties of vpiConstType
  typedef enum { vpiDecConst = 1        // decimal integer
                 , vpiRealConst = 2     // real
                 , vpiBinaryConst = 3   // binary integer
                 , vpiOctConst = 4      // octal integer
                 , vpiHexConst = 5      // hexadecimal integer
                 , vpiStringConst = 6   // string literal
                 , vpiIntConst = 7      // integer constant (1364-2001)
                 , vpiTimeConst = 8     // time constant
                 } vpi_const_type_e;

  // Sub-properties of vpiCaseType
  typedef enum { vpiCaseExact = 1   // exact match
                 , vpiCaseX = 2     // ignore X's
                 , vpiCaseZ = 3     // ignore Z's
                 } vpi_case_type_e;

  // Sub-properties of vpiFuncType
  typedef enum { vpiIntFunc = 1             // returns integer
                 , vpiRealFunc = 2          // returns real
                 , vpiTimeFunc = 3          // returns time
                 , vpiSizedFunc = 4         // returns an arbitrary size
                 , vpiSizedSignedFunc = 5   // returns sized signed value
                 } vpi_func_type_e;

  // Sub-properties of vpiDelayType
  typedef enum { vpiModPathDelay = 1         // module path delay
                 , vpiInterModPathDelay = 2  // intermodule path delay
                 , vpiMIPDelay = 3           // module input port delay
                 } vpi_delay_type_e;

  // Sub-properties of vpiIndexedPartSelectType
  typedef enum { vpiPosIndexed = 1  // +:
                 , vpiNegIndexed = 2  // -:
                 } vpi_indexed_part_select_type_e;

  typedef enum {
                // Generic object properties
                vpiUndefined = -1   // undefined property

                , vpiType = 1       // type of object
                , vpiName = 2       // local name of object
                , vpiFullName = 3   // full hierarchical name
                , vpiSize = 4       // size of gate, net, port, etc.
                , vpiFile = 5       // File name in which the object is used
                , vpiLineNo = 6     // line number where the object is used

                // Module properties
                , vpiTopModule = 7          // top-level module (boolean)
                , vpiCellInstance = 8       // cell (boolean)
                , vpiDefName = 9            // module definition name
                , vpiProtected = 10         // source protected module (boolean)
                , vpiTimeUnit = 11          // module time unit
                , vpiTimePrecision = 12     // module time precision
                , vpiDefNetType = 13        // default net type
                , vpiUnconnDrive = 14       // unconnected port drive strength
                , vpiDefFile = 15           // File name where the module is defined
                , vpiDefLineNo = 16         // line number for module definition
                , vpiDefDelayMode = 47      // Default delay mode for a module
                , vpiDefDecayTime = 48      // Default decay time for a module

                // Port and net properties
                , vpiScalar = 17             // scalar (boolean)
                , vpiVector = 18             // vector (boolean)
                , vpiExplicitName = 19       // port is explicitly named
                , vpiDirection = 20          // direction of port:
                , vpiConnByName = 21         // connected by name (boolean)
                , vpiNetType = 22            // net
                , vpiExplicitScalared = 23   // explicitly scalared (boolean)
                , vpiExplicitVectored = 24   // explicitly vectored (boolean)
                , vpiExpanded = 25           // expanded vector net (boolean)
                , vpiImplicitDecl = 26       // implicitly declared net (boolean)
                , vpiChargeStrength = 27     // charge decay strength of net

                , vpiArray = 28       // variable array (boolean)
                , vpiPortIndex = 29   // Port index

                // Gate and terminal properties
                , vpiTermIndex = 30   // Index of a primitive terminal
                , vpiStrength0 = 31   // 0-strength of net or gate
                , vpiStrength1 = 32   // 1-strength of net or gate
                , vpiPrimType = 33    // primitive

                // Path, path terminal, timing check properties
                , vpiPolarity = 34     // polarity of module path...
                , vpiDataPolarity = 35 // ...or data path:
                , vpiEdge = 36         // edge type of module path:
                , vpiPathType = 37     // path delay connection
                , vpiTchkType = 38     // timing check

                // Expression properties
                , vpiOpType = 39          // operation
                , vpiConstType = 40       // constant
                , vpiBlocking = 41        // blocking assignment (boolean)
                , vpiCaseType = 42        // case statement
                , vpiNetDeclAssign = 43   // assign part of decl (boolean)

                // task/function properties
                , vpiFuncType = 44  // function & system function type
                , vpiUserDefn = 45  // user-defined system task/func(boolean)
                , vpiScheduled = 46 // object still scheduled (boolean)

                // Properties added with 1364-2001
                , vpiActive = 49               // reentrant task/func frame is active
                , vpiAutomatic = 50            // task/func obj is automatic
                , vpiCell = 51                 // configuration cell
                , vpiConfig = 52               // configuration config file
                , vpiConstantSelect = 53       // (boolean) bit-select or part-select indices are constant expressions
                , vpiDecompile = 54            // decompile the object
                , vpiDefAttribute = 55         // Attribute defined for the obj
                , vpiDelayType = 56            // delay subtype
                , vpiIteratorType = 57         // object type of an iterator
                , vpiLibrary = 58              // configuration library
                , vpiOffset = 60               // offset from LSB
                , vpiResolvedNetType = 61      // net subtype after resolution, returns same subtypes as vpiNetType
                , vpiSaveRestartID = 62        // unique ID for save/restart data
                , vpiSaveRestartLocation = 63  // name of save/restart data file
                // !! vpiValid, vpiValidTrue, vpiValidFalse are deprecated in 1800-2009
                // vpiValid = 64  // reentrant task/func frame or automatic variable is valid
                // vpiValidFalse              0
                // vpiValidTrue               1
                //
                , vpiSigned = 65           // TRUE for vpiIODecl and any object in the expression class if the object has the signed attribute
                , vpiLocalParam = 70       // TRUE when a param is declared as a localparam
                , vpiModPathHasIfNone = 71 // Mod path has an ifnone statement

                // Properties added with 1364-2005
                , vpiIndexedPartSelectType = 72  // Indexed part-select type
                , vpiIsMemory = 73  // TRUE for a one-dimensional reg array
                , vpiIsProtected = 74  // TRUE for protected design information
                } vpi_prop_e;

  // vpi_control() constants (added with 1364-2001)
  typedef enum { vpiStop = 66                   // execute simulator's $stop
                 , vpiFinish = 67               // execute simulator's $finish
                 , vpiReset = 68                // execute simulator's $reset
                 , vpiSetInteractiveScope = 69  // set simulator's interactive scope
                 } vpi_control_e;

  // time types
  typedef enum { vpiScaledRealTime = 1
                 , vpiSimTime = 2
                 , vpiSuppressTime = 3
                 } vpi_time_type_e;

  typedef struct {
    vpi_time_type_e time_type;
    uint32_t high, low;        // for vpiSimTime
    real real_time;            // for vpiScaledRealTime
  } vpi_time_s;

  // delay structures

  typedef struct {
    vpi_time_s da;              // delay values
    int32_t no_of_delays;       // number of delays
    vpi_time_type_e time_type;
    int32_t mtm_flag;           // true for mtm values
    int32_t append_flag;        // true for append
    int32_t pulsere_flag;       // true for pulsere values
  } vpi_delay_s;

  // Value structures

  // vector value
  typedef struct {
    // following fields are repeated enough times to contain vector
    uint32_t aval, bval; // bit encoding: ab: 00=0, 10=1, 11=X, 01=Z
  } vpi_vecval_s;

  // strength (scalar) value
  typedef enum { vpiHiZ = 'h01
                 , vpiSmallCharge = 'h02
                 , vpiMediumCharge = 'h04
                 , vpiWeakDrive = 'h08
                 , vpiLargeCharge = 'h10
                 , vpiPullDrive = 'h20
                 , vpiStrongDrive = 'h40
                 , vpiSupplyDrive = 'h80
                 } vpi_strengthval_e;

  typedef struct {
    int32_t logic_val; // vpi[0, 1, X, Z]
    vpi_strengthval_e s0, s1;
  } vpi_strengthval_s;

  // generic value
  typedef enum { vpiBinStrVal = 1
                 , vpiOctStrVal = 2
                 , vpiDecStrVal = 3
                 , vpiHexStrVal = 4
                 , vpiScalarVal = 5
                 , vpiIntVal = 6
                 , vpiRealVal = 7
                 , vpiStringVal = 8
                 , vpiVectorVal = 9
                 , vpiStrengthVal = 10
                 , vpiTimeVal = 11
                 , vpiObjTypeVal = 12
                 , vpiSuppressVal = 13
                 , vpiShortIntVal = 14
                 , vpiLongIntVal = 15
                 , vpiShortRealVal = 16
                 , vpiRawTwoStateVal = 17
                 , vpiRawFourStateVal = 18
                 } vpi_value_format_e;

  // delay modes
  typedef enum { vpiNoDelay = 1
                 , vpiInertialDelay = 2
                 , vpiTransportDelay = 3
                 , vpiPureTransportDelay = 4
                 } vpi_delay_mode_e;

  // // force and release flags

  // vpiForceFlag          5
  // vpiReleaseFlag        6

  // // scheduled event cancel flag
  // vpiCancelEvent        7

  // // bit mask for the flags argument to vpi_put_value()
  // vpiReturnEvent        0x1000

  // // bit flags for vpi_get_value_array flags field
  // vpiUserAllocFlag      0x2000

  // // bit flags for vpi_put_value_array flags field
  // vpiOneValue           0x4000
  // vpiPropagateOff       0x8000

  // scalar values
  typedef enum { vpi0 = 0
                 , vpi1 = 1
                 , vpiZ = 2
                 , vpiX = 3
                 , vpiH = 4
                 , vpiL = 5
                 , vpiDontCare = 6
                 , vpiValNoChange = 7 // Originally was vpiNoChange, but renamed it
                 // to prevent clash with vpi_tchk_type_e.vpiNoChange
                 } vpi_scalar_value_e;

  typedef enum { vpiSysTask = 1
                 , vpiSysFunc = 2 // the subtypes are defined under the vpiFuncType property
                 } vpi_task_func_e;

  // state when error occurred
  typedef enum { vpiCompile = 1
                 , vpiPLI = 2
                 , vpiRun = 3
                 } vpi_state_e;

  // error severity levels
  typedef enum { vpiNotice = 1
                 , vpiWarning = 2
                 , vpiError = 3
                 , vpiSystem = 4
                 , vpiInternal = 5
                 } vpi_error_severity_e;

  // Callback Reasons
  typedef enum {
                // Simulation related
                cbValueChange = 1
                , cbStmt = 2
                , cbForce = 3
                , cbRelease = 4

                // Time related
                , cbAtStartOfSimTime = 5
                , cbReadWriteSynch = 6
                , cbReadOnlySynch = 7
                , cbNextSimTime = 8
                , cbAfterDelay = 9

                // Action related
                , cbEndOfCompile = 10
                , cbStartOfSimulation = 11
                , cbEndOfSimulation = 12
                , cbError = 13
                , cbTchkViolation = 14
                , cbStartOfSave = 15
                , cbEndOfSave = 16
                , cbStartOfRestart = 17
                , cbEndOfRestart = 18
                , cbStartOfReset = 19
                , cbEndOfReset = 20
                , cbEnterInteractive = 21
                , cbExitInteractive = 22
                , cbInteractiveScopeChange = 23
                , cbUnresolvedSystf = 24

                // Added with 1364-2001
                , cbAssign = 25
                , cbDeassign = 26
                , cbDisable = 27
                , cbPLIError = 28
                , cbSignal = 29

                // Added with 1364-2005
                , cbNBASynch = 30
                , cbAtEndOfSimTime = 31
                } vpi_cb_reason_e;

  typedef chandle VpiHandle;

  // context is needed for calling VPI from DPI imported routines
  import "DPI-C" context function VpiHandle vpi_handle_by_name(input string name, VpiHandle scope = null /*current scope*/);
  import "DPI-C" context function VpiHandle vpi_iterate(input vpi_object_type_e obj_type, VpiHandle _ref);
  import "DPI-C" context function VpiHandle vpi_scan(input VpiHandle itr);
  import "DPI-C" context function string    vpi_get_str(input vpi_prop_e prop, VpiHandle obj);
  import "DPI-C" context function VpiHandle vpi_handle(input vpi_methods_e method, VpiHandle obj);
  import "DPI-C" context function int       vpi_get(input vpi_prop_e prop, VpiHandle handle);
  import "DPI-C" context function int       vpi_get_value_int(input VpiHandle handle);
  import "DPI-C" context function void      vpi_put_value_int(input VpiHandle handle, int value);

endpackage : vpi_pkg
